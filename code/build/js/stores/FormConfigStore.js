var _ = require('lodash');
var assign = require('object-assign');
var EventEmitter = require('events').EventEmitter;

var FormConfigStore = assign({}, EventEmitter.prototype);

FormConfigStore.genericFormTypes = function(){
  return [
    'IssuerCreateUpdateForm',
    'BadgeClassCreateUpdateForm',
    'BadgeInstanceCreateUpdateForm',
    'EarnerBadgeImportForm',
    'EarnerCollectionCreateForm',
    'EarnerCollectionEditForm',
    'CollectionAddBadgeInstanceForm',
  ];
}

FormConfigStore.getConfig = function(formType, overrides, context){
  if (!overrides)
    overrides = {};
  if (!context)
    context = {};

  function contextGet(key, defaultValue){
    if (context.hasOwnProperty(key))
      return context[key];
    return defaultValue;
  }

  var family_data = function() {
    var tmp = new Array();
    var family;
    tmp[tmp.length] = {};
    var APIStore = require('../stores/APIStore');
    var collection = APIStore.getCollection('issuer_familyclasses');
    collection.forEach(function (value, index) {
      family = {'id':value.id, 'name':value.name};
      tmp[tmp.length] = family;
    })
    return JSON.stringify(tmp);
  }

  var category_data = function () {
    var tmp = new Array();
    tmp[tmp.length] = {};
    var APIStore = require('../stores/APIStore');
    var collection = APIStore.getCollection('issuer_categoryclasses');
    // var collection = APIStore.getCollection('familyclasses', 'family_id', );
    collection.forEach(function (value, index) {
      category = {'id':value.id, 'name':value.name};
      tmp[tmp.length] = category;
    })
    return JSON.stringify(tmp);
  }

  var configDefaults = {
    IssuerCreateUpdateForm: {
      formId: overrides['formId'] || "IssuerCreateUpdateForm",
      fieldsMeta: {
        name: {inputType: "text", label: "Issuer Name", required: true},
        description: {inputType: "textarea", label: "Issuer Description", required: true},
        url: {inputType: "text", label: "Website URL", required: true},
        email: {inputType: "text", label: "Contact Email", required: true},
        image: {inputType: "image", label: "Logo (Square PNG)", required: false, filename: "issuer_logo.png"}
      },
      defaultValues: {
        name: "",
        description: "",
        url: "",
        email: "",
        image: null,
        imageData: null,
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['name', 'description', 'url', 'email'], className:'' },
        { fields: ['image'], className:'' },
      ],
      formControls: {
        "submit": {"label": "Add Issuer"}
      },
      apiContext: {
        formId: overrides['formId'] || "IssuerCreateUpdateForm",
        apiCollectionKey: "issuer_issuers",
        actionUrl: "/v1/issuer/issuers",
        method: "POST",
        successHttpStatus: [200, 201],
        successMessage: "New issuer created"
      }
    },

    BadgeClassCreateUpdateForm: {
      formId: overrides['formId'] || "BadgeClassCreateUpdateForm",
      fieldsMeta: {
        name: {inputType: "text", label: "Badge Name", required: true},
        // family:{inputType:"select", selectOptions: eval(family_data()), label:"Badge family", required:true },
        family:{inputType:"select", selectOptions: eval(family_data()), label:"Badge family", required:true, change: function(){alert("ssdfds")} },
        category:{inputType:"select", selectOptions: eval(category_data()), label:"Badge category",required:true},
        // category:{inputType:"select", selectOptions: [], label:"Badge category",required:true},
        order:{inputType:"text",label:"Badge order",required:true},
        description: {inputType: "textarea", label: "Badge Description", required: true},
        criteria: {inputType: "textarea", label: "Criteria URL or text", required: true},
        image: {inputType: "image", label: "Badge Image (Square PNG)", required: true, filename: "badge_image.png"}
      },
      defaultValues: {
        name: "",
        description: "",
        criteria: "",
        image: null,
        imageData: null,
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['name', 'family', 'category', 'order', 'description', 'criteria'], className:''},
        { fields: ['image'], className:'' }
      ],
      apiContext: {
        formId: overrides['formId'] || "BadgeClassCreateUpdateForm",
        apiCollectionKey: "issuer_badgeclasses",
        actionUrl: "/v1/issuer/issuers/" + contextGet('issuerSlug', '') + "/badges",
        method: "POST",
        successHttpStatus: [200, 201],
        successMessage: "New badge class created"
      }
    },
    BadgeInstanceCreateUpdateForm: {
      formId: overrides['formId'] || "BadgeInstanceCreateUpdateForm",
      fieldsMeta: {
        email: {inputType: "text", label: "Recipient Email", required: true},
        evidence: {inputType: "text", label: "Evidence URL", required: false},
        expires: {inputType: "text", label: "Expires (yyyy-mm-dd)", required: false},
        create_notification: {inputType: "checkbox", label: "Notify earner by email", required: false}
      },
      defaultValues: {
        email: "",
        evidence: "",
        create_notification: false,
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['email', 'evidence', 'expires', 'create_notification'], className:'col-xs-12' }
      ],
      apiContext: {
        formId: overrides['formId'] || "BadgeInstanceCreateUpdateForm",
        apiCollectionKey: "issuer_badgeinstances",
        actionUrl: "/v1/issuer/issuers/" + contextGet('issuerSlug', '') + "/badges/" + contextGet('badgeClassSlug', '') + '/assertions',
        method: "POST",
        successHttpStatus: [200, 201],
        successMessage: "Badge successfully issued."
      }
    },
    EarnerBadgeImportForm: {
      formId: "EarnerBadgeImportForm",
      //helpText: "Verify an Open Badge and add it to your library by uploading a badge image or entering its URL.",
      fieldsMeta: {
        image: {inputType: "image", label: "Badge Image", required: false, filename: "earned_badge.png"},
        url: {inputType: "text", label: "Assertion URL", required: false},
        assertion: {inputType: "textarea", label: "Assertion JSON", required: false}
      },
      defaultValues: {
        image: null,
        imageData: null,
        url: contextGet('url', ''),
        assertion: "",
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['url', 'assertion'], className:'' },
        { fields: ['image'], className:'' },
      ],
      formControls: {
        "submit": {"label": "Import Badge"}
      },
      apiContext: {
        formId: overrides['formId'] || "EarnerBadgeImportForm",
        apiCollectionKey: "earner_badges",
        actionUrl: "/v1/earner/badges",
        method: "POST",
        successHttpStatus: [200, 201],
        successMessage: "Badge successfully imported."
      }
    },
    EarnerCollectionCreateForm: {
      formId: overrides['formId'] || "EarnerCollectionCreateForm",
      fieldsMeta: {
        name: {inputType: "text", label: "Name", required: true},
        description: {inputType: "textarea", label: "Description", required: false}
      },
      defaultValues: {
        name: "",
        description: "",
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['name', 'description'], className:'col-xs-12' },
      ],
      apiContext: {
        formId: overrides['formId'] || "EarnerCollectionCreateForm",
        apiCollectionKey: "earner_collections",
        actionUrl: "/v1/earner/collections",
        method: "POST",
        successHttpStatus: [200, 201],
        successMessage: "Collection successfully created."
      }
    },
    EarnerCollectionEditForm: {
      formId: overrides['formId'] || "EarnerCollectionEditForm",
      fieldsMeta: {
        name: {inputType: "text", label: "Name", required: true},
        description: {inputType: "textarea", label: "Description", required: false}
      },
      defaultValues: {
        name: contextGet('collection',{name:''}).name,
        description: contextGet('collection',{description:''}).description,
        actionState: "ready",
        message: ""
      },
      columns: [
        { fields: ['name', 'description'], className:'col-xs-12' },
      ],
      apiContext: {
        formId: overrides['formId'] || "EarnerCollectionEditForm",
        apiCollectionKey: "earner_collections",
        actionUrl: "/v1/earner/collections/" + contextGet('collection', {slug:''}).slug,
        method: "PUT",
        successHttpStatus: [200],
        successMessage: "Collection successfully edited."
      }
    },
    CollectionAddBadgeInstanceForm: {
        formId: overrides['formId'] || "CollectionAddBadgeInstanceForm",

        columns: [
            { fields: ['collection', 'id'], className: '' },
        ],
        fieldsMeta: {
            collection: {inputType: 'select', selectOptions: contextGet('collections'), label: '', required: true},
            id: {inputType: 'hidden', label: '', required: true},
        },

        defaultValues: {
            actionState: "ready",
            message: "",
            collection: contextGet('defaultCollection'),
            id: contextGet('badgeId'),
        },

        apiContext: {
            formId: overrides['formId'] || "CollectionAddBadgeInstanceForm",
            apiCollectionKey: "earner_collections",
            actionUrl: "/v1/earner/collections/:collection/badges",
            method: "POST",
            successHttpStatus: [201],
            successMessage: contextGet('badgeName') +" added to collection.",
            updateFunction: function(request, APIStore, requestContext) {
                var collection = APIStore.filter(this.apiCollectionKey, 'slug', requestContext.collection)[0];
                collection.badges.push(request.body);
                return request.body;
            },
        },
    },
  };

  var configData = configDefaults[formType] || {};
  return _.defaults(overrides, configData);
};


module.exports = {
  genericFormTypes: FormConfigStore.genericFormTypes,
  getConfig: FormConfigStore.getConfig
}
