var _ = require("lodash");

var Dispatcher = require('../dispatcher/appDispatcher');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var request = require('superagent');

var FormStore = require('../stores/FormStore');
var APIActions = require('../actions/api');

function getCookie(name) {
    var cookieValue = null;
    if (document.cookie) {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

var APIStore = assign({}, EventEmitter.prototype);

APIStore.data = {};
APIStore.getRequests = [];
APIStore.activeGetRequests = {};


APIStore.collectionsExist = function(collections){
  for (var index in collections){
    if (!APIStore.data.hasOwnProperty(collections[index]))
      return false;
  }
  return true;
};

APIStore.removeCollections = function(collections) {
  for (var index in collections){
    if (APIStore.data.hasOwnProperty(collections[index])) {
      delete APIStore.data[collections[index]];
    }
  }
};

APIStore.collectionExists = function(collectionKey) {
    return APIStore.data.hasOwnProperty(collectionKey);
};

APIStore.getCollection = function(collectionType) {
    if (APIStore.data.hasOwnProperty(collectionType)) {
        var collection = APIStore.data[collectionType];
        // Create a copy so the caller cannot not directly mutate the store
        if (collection instanceof Array) {
            return collection.map(function(item) {
                return _.extend({}, item);
            });
        }
        else {
            // A collection can be a single object not an array of collection items
            return _.extend({}, collection);
        }
    }
    return [];
};
APIStore.getCollectionLastItem = function(collectionType) {
    var collection = APIStore.getCollection(collectionType);
    if (collection.length > 0) {
        return collection[collection.length - 1];
    }
    return {};
};
APIStore.getFirstItemByPropertyValue = function(collectionType, propName, value){
  // Will return the first item that matches -- don't use for queries where you want multiple results.
  var collection = APIStore.getCollection(collectionType);

  for (var i=0; i < collection.length; i++){
      if (collection[i].hasOwnProperty(propName) && collection[i][propName] == value){
          return collection[i];
      }
  }
  return {};
};
APIStore.filter = function(collectionType, propName, value){
  function match(item) {
    if (Array.isArray(value))
      return (item.hasOwnProperty(propName) && value.indexOf(item[propName]) > -1);
    else
      return (item.hasOwnProperty(propName) && item[propName] == value);
  }

  var collection = APIStore.getCollection(collectionType);
  return collection.filter(match);
};

APIStore.addCollectionItem = function(collectionKey, item, isNew){
  if (!APIStore.data.hasOwnProperty(collectionKey))
    APIStore.data[collectionKey] = [];
  if (!isNew)
    APIStore.data[collectionKey].push(item);
  else
    return APIStore.replaceCollectionItem(collectionKey, item);
  return item;
}

APIStore.replaceCollectionItem = function(collectionKey, item){
  var key;
  if (collectionKey == 'earner_collections'){
    key = 'slug';
  }
  else {
    key = 'id';
  }

  foundIndex = _.findIndex(APIStore.data[collectionKey], function(el){ return el[key] == item[key]; });
  if (foundIndex > -1)
    APIStore.data[collectionKey][foundIndex] = item;
  else
    APIStore.data[collectionKey].push(item);
  return item;
};

APIStore.updateReplaceOrCreateCollectionItem = function(collectionKey, searchKey, searchValue, updateKey, newItem, pushItem){

  if (!APIStore.data.hasOwnProperty(collectionKey)) {
      // Warning: Create a collection that has a single Item that may be an object or JUST A STRING!
    return APIStore.addCollectionItem(collectionKey, newItem);
  }

  var foundIndex = _.findIndex(APIStore.data[collectionKey], function(el){ return el[searchKey] == searchValue; });
  if (foundIndex > -1){
    // Optional updateKey parameter lets you update a single field/property. Without it, replace the whole object.
    if (updateKey) {
        var itemField = APIStore.data[collectionKey][foundIndex][updateKey];
        if (pushItem && typeof itemField.push === 'function') {
            APIStore.data[collectionKey][foundIndex][updateKey].push(newItem);
        }
        else {
            APIStore.data[collectionKey][foundIndex][updateKey] = newItem;
        }
    }
    else {
      APIStore.data[collectionKey][foundIndex] = newItem;
    }

    return APIStore.data[collectionKey][foundIndex]
  }
};

APIStore.hasAlreadyRequested = function(path){
  return (APIStore.getRequests.indexOf(path) > -1);
};

APIStore.resolveActiveGet = function(collectionKey){
  if (APIStore.activeGetRequests.hasOwnProperty(collectionKey))
    delete APIStore.activeGetRequests[collectionKey];
};


// listener utils
APIStore.setMaxListeners(40);
APIStore.addListener = function(type, callback) {
  APIStore.on(type, callback);
};

// wrap eventemitter so it gets the same object as when addListener was called
APIStore.removeStoreListener = function(type, callback) {
  APIStore.removeListener(type, callback)
}


// on startup
APIStore.storeInitialData = function() {
  var _initialData;

  // try to load the variable declared as initialData in the view template
  if (initialData) {
    // TODO: Add validation of types?
    _initialData = initialData
    for (var key in _initialData){
      APIStore.data[key] = _initialData[key]
    }
  }
};

APIStore.defaultContexts = {
    earner_badges: {
      actionUrl: '/v1/earner/badges',
      successfulHttpStatus: [200],
      apiCollectionKey: 'earner_badges',
      replaceCollection: true
    },
    earner_collections: {
      actionUrl: '/v1/earner/collections',
      successfulHttpStatus: [200],
      apiCollectionKey: 'earner_collections',
      replaceCollection: true
    },
    issuer_issuers: {
      actionUrl: '/v1/issuer/issuers',
      successfulHttpStatus: [200],
      apiCollectionKey: 'issuer_issuers',
      replaceCollection: true
    },
    issuer_badgeclasses: {
      actionUrl: '/v1/issuer/all-badges',
      successfulHttpStatus: [200],
      apiCollectionKey: 'issuer_badgeclasses',
      replaceCollection: true
    },
    badgebook_courseobjectives: {
      actionUrl: '/v1/badgebook/courseobjectives/:tool_guid/:course_id',
      successfulHttpStatus: [200],
      apiCollectionKey: 'badgebook_courseobjectives',
      replaceCollection: true
    },
    badgebook_badgeobjectives: {
      actionUrl: '/v1/badgebook/badgeobjectives/:tool_guid/:course_id',
      successfulHttpStatus: [200],
      apiCollectionKey: 'badgebook_badgeobjectives',
      replaceCollection: true
    },
    badgebook_courseprogress: {
      actionUrl: '/v1/badgebook/studentobjectives/:tool_guid/:course_id',
      successfulHttpStatus: [200],
      apiCollectionKey: 'badgebook_courseprogress',
      replaceCollection: true
    },
    badgebook_badgeinstances: {
      actionUrl: '/v1/badgebook/badgeinstances/:tool_guid/:course_id/:student_id',
      successfulHttpStatus: [200],
      apiCollectionKey: 'badgebook_badgeinstances',
      replaceCollection: true,
      formId: 'badgebook_badgeinstances',
    },
    badgebook_checkcourseprogress: {
        actionUrl: '/v1/badgebook/checkprogress/:tool_guid/:course_id?page=:page',
        successfulHttpStatus: [200, 204],
        apiCollectionKey: 'badgebook_checkcourseprogress',
        replaceCollection: true,
        formId: 'badgebook_checkcourseprogress',
    },
    badgebook_checkstudentprogress: {
      actionUrl: '/v1/badgebook/checkprogress/:tool_guid/:course_id/:student_id',
      successfulHttpStatus: [200, 204],
      apiCollectionKey: 'badgebook_checkstudentprogress',
      replaceCollection: true,
      formId: 'badgebook_checkstudentprogress',
    },
    badgebook_leaderboard: {
        actionUrl: '/v1/badgebook/leaderboard/:tool_guid/:course_id?page=:page',
        successfulHttpStatus: [200, 204],
        apiCollectionKey: 'badgebook_leaderboard',
        replaceCollection: true,
    },
};

APIStore.fetchCollections = function(collectionKeys, requestContext){
  var actionUrl, key;
  for (var index in collectionKeys){
    key = collectionKeys[index];
    if (!APIStore.defaultContexts.hasOwnProperty(key))
      continue;
    actionUrl = APIStore.buildUrlWithContext(APIStore.defaultContexts[key].actionUrl, requestContext)
    if (APIStore.activeGetRequests.hasOwnProperty(actionUrl))
      continue;
    APIStore.activeGetRequests[actionUrl] = true;
    APIStore.getData(APIStore.defaultContexts[key], requestContext);
  }
};

APIStore.fetchCollectionPage = function(collectionKey, page_url, requestContext) {
  if (APIStore.activeGetRequests.hasOwnProperty(page_url))
    return;
  APIStore.activeGetRequests[page_url] = true;
  APIStore.getData(APIStore.defaultContexts[collectionKey], requestContext, page_url);

}

APIStore.reloadCollections = function(collectionKeys, requestContext) {
  for (var index in collectionKeys) {
    var pagination_url = undefined;
    var key = collectionKeys[index];
    var idx = key ? key.indexOf(':') : -1;
    if (idx != -1) {
      pagination_url = key.substring(idx+1)
      key = key.substring(0, idx)
    }
    if (APIStore.defaultContexts.hasOwnProperty(key)) {
      var apiContext = APIStore.defaultContexts[key];
      var actionUrl = APIStore.buildUrlWithContext(apiContext.actionUrl, requestContext);
      if (!APIStore.activeGetRequests.hasOwnProperty(actionUrl)) {
        APIStore.activeGetRequests[actionUrl] = true;
        APIStore.getData(apiContext, requestContext, pagination_url);
      }
    }
  }

  return;
}

APIStore.buildUrlWithContext = function(url, context) {
  return url.replace(/:(\w+)/g, function(replace) {
    return context[replace.substring(1)];
  });
}

/* getData(): a common function for GETting needed data from the API so
 * that views may be rendered.
 * Params:
 *   context: a dictionary providing information about the API endpoint,
 *            expected return results and what to do with it.
 *       - actionUrl: the path starting with / to request from
 *       - successfulHttpStatus: [200] an array of success status codes
 *       - apiCollectionKey: where to put the retrieved data
 *
 *   requestContext: a dictionary providing context values for this particular request
*/
APIStore.getData = function(context, requestContext, pagination_url, retriedAttempt) {

  var url = pagination_url || APIStore.buildUrlWithContext(context.actionUrl, requestContext)

  APIStore.getRequests.push(url);

  var req = request.get(url)
    .accept('application/json');

    var cookie = getCookie('csrftoken');
    if (cookie) {
        req.set('X-CSRFToken', cookie);
    }

    var token = _.get(APIStore.getCollection('user'), 'token');
    if (token) {
        req.set('Authorization', 'Token '+ token);
    }

  req.end(function(error, response){
    APIStore.resolveActiveGet(context.apiCollectionKey);
    APIStore.resolveActiveGet(url);
    if (error){
      APIStore.emit('API_STORE_FAILURE');
    }
    else if (response.status == 202) {
      var resume = response.body.resume;
      var wait = response.body.wait || 8;
      if (resume && url.indexOf('resume=') == -1) {
        url += (url.indexOf('?') == -1 ? '?' : '&')+"resume="+resume;
      }
      setTimeout(function() {
        APIStore.getData(context, requestContext, url, pagination_url ? false : true)
      }.bind(this), wait*1000);
    }
    else if (context.successfulHttpStatus.indexOf(response.status) == -1){
      var errorContent;
      try {
          errorContent = JSON.parse(response.text);
      }
      catch(e){
          errorContent = response.text;
      }

      var errorMessage = _.get(errorContent, 'detail', errorContent);
      APIActions.APIGetResultFailure({
        message: {type: 'danger', content: response.status + " Error getting data: " + errorMessage}
      });
    }
    else {
      if (response.header.link) {
        var links = {}
        response.header.link.replace(/<([^>]+)>; rel="([^"]+)"/g, function(all, link, name) {
          links[name] = link
        });
        APIStore.emit('DATA_PAGINATION_LINKS', context.apiCollectionKey+":"+url, links)
      }

      var collectionKey = context.apiCollectionKey;
      if (pagination_url && !retriedAttempt) {
        // strip any resume argument from pagination_url
        pagination_url = pagination_url.replace(/[&?]resume=[0-9a-f-]+/i, '');

        // this was a response to a next/prev page request
        collectionKey = context.apiCollectionKey+":"+pagination_url;
      }

      if ( ! APIStore.collectionExists(collectionKey) || context['replaceCollection']){
        APIStore.data[collectionKey] = [];
      }

      if (Array.isArray(response.body)){
        response.body.map(function(el, i, array){
          APIStore.addCollectionItem(collectionKey, el);
        });
      }
      else if (response.body !== null){
        APIStore.addCollectionItem(collectionKey, response.body);
      }

      APIStore.emit('DATA_UPDATED');
      if (context.hasOwnProperty('formId')) {
        APIStore.emit('DATA_UPDATED_'+context.formId);
      }
    }
  });

  return req;
};


/* postForm(): a common function for POSTing forms and returning results
 * to the FormStore.
 * Params:
 *   context: a dictionary providing information about the API endpoint
 *            and expected return results.
 *   fields: the form data from the FormStore.
 * This function will interrogate the data and attach appropriate fields
 * to the post request.
*/
APIStore.postForm = function(fields, values, context, requestContext){
  url = APIStore.buildUrlWithContext(context.actionUrl, requestContext)

  if (context.method == 'POST')
    var req = request.post(url);
  else if (context.method == 'DELETE')
    var req = request.del(url);
  else if (context.method == 'PUT')
    var req = request.put(url);

  req.accept('application/json');

  var cookie = getCookie('csrftoken');
  if (cookie) {
      req.set('X-CSRFToken', cookie);
  }

  var token = _.get(APIStore.getCollection('user'), 'token');
  if (token) {
      req.set('Authorization', 'Token '+ token);
  }

  // Attach data fields to request
  for (var field in fields) {
    if (["text", "hidden", "textarea", "select", "checkbox"].indexOf(fields[field].inputType) > -1 && values[field])
      req.field(field, values[field]);
    else if (["image", "file"].indexOf(fields[field].inputType) > -1 && values[field] != null)
      req.attach(field, values[field], _.get(values[field], 'name', fields[field].filename));
  }

  req.end(function(error, response){
    if (error){
      APIStore.emit('API_STORE_FAILURE');
    }
    else if (context.successHttpStatus.indexOf(response.status) == -1){
      APIActions.APIFormResultFailure({
        formId: context.formId,
        message: {
          type: 'danger',
          content: "Error submitting form: (" + response.status + ').',
          detail: JSON.parse(response.text)
        }
      });
    }
    else {
      if (typeof context.updateFunction === "function"){
        newObject = context.updateFunction(response, APIStore, requestContext);
      }
      else {
        newObject = APIStore.addCollectionItem(context.apiCollectionKey, JSON.parse(response.text), (context.method == 'PUT'));
        if ( ! newObject) {
            APIStore.emit('API_STORE_FAILURE');
            return;
        }
      }

      APIStore.emit('DATA_UPDATED', context.apiCollectionKey);
      if (context.formId) {
          APIActions.APIFormResultSuccess({
              formId: context.formId,
              message: {type: 'success', content: context.successMessage},
              result: newObject
          });
      }
    } 
  });

  return req;
}


/* updateWithResponseData: a method of making partial updates to collection records based on
 * an API interaction.
*/
APIStore.updateWithResponseData = function(data, context, requestContext){
  url = APIStore.buildUrlWithContext(context.actionUrl, requestContext)

  var req;
  if (context.method == 'POST')
    req = request.post(url);
  else if (context.method == 'DELETE')
    req = request.del(url);
  else if (context.method == 'PUT')
    req = request.put(url);
  else if (context.method == 'GET')
    req = request.get(url);

  req.set('X-CSRFToken', getCookie('csrftoken'))
  .accept('application/json')

  if (data)
    req.type('application/json');

  req.send(data);

  req.end(function(error, response){
    if (error){
      APIStore.emit('API_STORE_FAILURE');
    }
    else if (context.successHttpStatus.indexOf(response.status) == -1){
      APIStore.emit("API_RESULT")
    }
    else if (context.method == 'DELETE' && ! context.doNotDeleteCollection){
      var foundIndex = _.findIndex(_.get(APIStore.data, context.apiCollectionKey), function(el){ return el[context.apiSearchKey] == context.apiSearchValue; });
      if (foundIndex > -1) {
        APIStore.data[context.apiCollectionKey].splice(foundIndex, 1);
        APIStore.emit('DATA_UPDATED');
        APIStore.emit('DATA_UPDATED_' + context.apiCollectionKey);

        if (context.successFunction) {
            context.successFunction(response, APIStore, requestContext);
        }

        if (context.hasOwnProperty('formId'))
          APIStore.emit('DATA_UPDATED_' + context.formId);
      }
    }
    else {
        var apiResponse = typeof response.text == 'string' && response.text ? JSON.parse(response.text) : '';

        var updateCollectionItemField = ( ! context.apiUpdateValuesTo && ! context.apiUpdateValuesFromResponse && context.apiUpdateFieldWithResponse);

        if (updateCollectionItemField) {
            if (context.pushResponseToField) {
                var updatedObject = APIStore.updateReplaceOrCreateCollectionItem(context.apiCollectionKey, context.apiSearchKey, context.apiSearchValue, context.apiUpdateFieldWithResponse, apiResponse, true);
            }
            else {
                var updatedObject = APIStore.updateReplaceOrCreateCollectionItem(context.apiCollectionKey, context.apiSearchKey, context.apiSearchValue, context.apiUpdateFieldWithResponse, apiResponse);
            }
            if ( ! updatedObject) {
                APIStore.emit('API_STORE_FAILURE');
            }
        }
        else if (context.apiUpdateValuesTo) {
            for (var key in context.apiUpdateValuesTo) {
                var value = context.apiUpdateValuesTo[key];
                APIStore.updateReplaceOrCreateCollectionItem(context.apiCollectionKey, context.apiSearchKey, context.apiSearchValue, key, value);
            }
        }
        else if (context.apiUpdateValuesFromResponse) {
            context.apiUpdateValuesFromResponse.forEach(function(key) {
                var value;  // If the response doesn't have any JSON keys, there are no values.
                if (typeof apiResponse === "object") {
                    value = apiResponse[key] || undefined;
                }
                APIStore.updateReplaceOrCreateCollectionItem(context.apiCollectionKey, context.apiSearchKey, context.apiSearchValue, key, value);
            });
        }
        else {
            APIStore.emit('API_STORE_FAILURE');
            return;
        }

        APIStore.emit('DATA_UPDATED');
        APIStore.emit('DATA_UPDATED_' + context.apiCollectionKey);
        if (context.hasOwnProperty('formId')) {
            APIStore.emit('DATA_UPDATED_' + context.formId);
        }
    } 
  });

  return req;
}



// Register with the dispatcher
APIStore.dispatchToken = Dispatcher.register(function(payload){
  
  var action = payload.action;

  switch(action.type){
    case 'APP_WILL_MOUNT':
      APIStore.storeInitialData();
      APIStore.emit('INITIAL_DATA_LOADED');
      break;

    case 'FORM_SUBMIT':
      // make sure form updates have occurred before processing submits
      Dispatcher.waitFor([FormStore.dispatchToken]);

      var formData = FormStore.getFormData(action.formId);
      APIStore.postForm(formData.fieldsMeta, formData.formState, formData.apiContext, action.requestContext || {});
      break;

    case 'API_POST_FORM':
      APIStore.postForm(action.fields, action.values, action.apiContext, action.requestContext || {});
      break;

    case 'API_SUBMIT_DATA':
      APIStore.updateWithResponseData(action.apiData, action.apiContext, action.requestContext || {});
      break;

    case 'API_GET_DATA':
      APIStore.getData(action.apiContext, action.requestContext || {});
      break;

    case 'API_GET_RESULT_FAILURE':
      APIStore.emit("API_GET_RESULT_FAILURE", action.message);
      break;

    case 'API_FETCH_COLLECTIONS':
      APIStore.fetchCollections(action.collectionIds, action.requestContext || {});
      break;

    case 'API_FETCH_COLLECTION_PAGE':
      APIStore.fetchCollectionPage(action.collectionKey, action.paginationUrl, action.requestContext || {});
      break;

    case 'API_RELOAD_COLLECTIONS':
      APIStore.reloadCollections(action.collectionIds, action.requestContext || {});
      break;

    default:
      // do naaathing.
  }
});

module.exports = {
  addListener: APIStore.addListener,
  removeListener: APIStore.removeStoreListener,
  hasAlreadyRequested: APIStore.hasAlreadyRequested,
  collectionsExist: APIStore.collectionsExist,
  removeCollections: APIStore.removeCollections,
  getCollection: APIStore.getCollection,
  getCollectionLastItem: APIStore.getCollectionLastItem,
  getFirstItemByPropertyValue: APIStore.getFirstItemByPropertyValue,
  filter: APIStore.filter,
  fetchCollection: APIStore.fetchCollection,
  buildUrlWithContext: APIStore.buildUrlWithContext,
  getCookie: APIStore.getCookie,
};
