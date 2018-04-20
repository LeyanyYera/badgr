var appDispatcher = require("../dispatcher/appDispatcher");

var APIFormResultSuccess = function(data) {
  appDispatcher.dispatch({ action: {
      type: 'API_FORM_RESULT_SUCCESS',
      formId: data.formId,
      formType: data.formType,
      message: data.message,
      result: data.result
    }});
}

var APIFormResultFailure = function(data) {
  appDispatcher.dispatch({ action: {
      type: 'API_FORM_RESULT_FAILURE',
      formId: data.formId,
      formType: data.formType,
      message: data.message
    }});
}

var APIGetData = function(apiContext, requestContext) {
  appDispatcher.dispatch({ action: {
      type: 'API_GET_DATA',
      apiContext: apiContext,
      requestContext: requestContext
    }});
}

var APISubmitData = function(data, apiContext, requestContext){
  appDispatcher.dispatch({ action: {
    type: 'API_SUBMIT_DATA',
    apiData: data,
    apiContext: apiContext,
    requestContext: requestContext
  }});
}

var APIGetResultFailure = function(data) {
  appDispatcher.dispatch({ action: {
      type: 'API_GET_RESULT_FAILURE',
      message: data.message
    }});
}

var APIFetchCollections = function(collectionKeys, requestContext) {
  appDispatcher.dispatch({ action: {
    type: 'API_FETCH_COLLECTIONS',
    collectionIds: collectionKeys,
    requestContext: requestContext
  }}); 
}

var APIReloadCollections = function(collectionKeys, requestContext) {
    appDispatcher.dispatch({ action: {
        type: 'API_RELOAD_COLLECTIONS',
        collectionIds: collectionKeys,
        requestContext: requestContext
    }});
}

var APIFetchCollectionPage = function(collectionKey, url, requestContext) {
  appDispatcher.dispatch({ action: {
    type: 'API_FETCH_COLLECTION_PAGE',
    collectionKey: collectionKey,
    requestContext: requestContext,
    paginationUrl: url
  }});
}

var APIPostForm = function(fields, values, apiContext, requestContext) {
  appDispatcher.dispatch({ action: {
    type: 'API_POST_FORM',
    fields: fields,
    values: values,
    apiContext: apiContext,
    requestContext: requestContext
  }});
}


module.exports = {
  APIFormResultSuccess: APIFormResultSuccess,
  APIFormResultFailure: APIFormResultFailure,
  APIGetResultFailure: APIGetResultFailure,
  APIGetData: APIGetData,
  APIFetchCollections: APIFetchCollections,
  APIFetchCollectionPage: APIFetchCollectionPage,
  APIReloadCollections: APIReloadCollections,
  APISubmitData: APISubmitData,
  APIPostForm: APIPostForm,
}
