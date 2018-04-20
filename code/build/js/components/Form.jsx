var React = require('react');
var ReactPropTypes = React.PropTypes;
var _ = require('lodash');

// Stores
var APIStore = require('../stores/APIStore');
var FormStore = require('../stores/FormStore');

// Components
var OpenBadge = require('../components/BadgeDisplay.jsx').OpenBadge;
var Dropzone = require('react-dropzone');

var Button = require('../components/Button.jsx').Button;

// Actions
var EarnerActions = require('../actions/earner');
var FormActions = require('../actions/forms');



/* Form components */
var InputGroup = React.createClass({
  propTypes: {
    name: ReactPropTypes.string,
    label: ReactPropTypes.string,
    inputType: ReactPropTypes.string,
    selectOptions: ReactPropTypes.arrayOf(ReactPropTypes.string),
    handleChange: ReactPropTypes.func,
    placeholder: ReactPropTypes.string,
    hint: ReactPropTypes.string,
    required: ReactPropTypes.bool,
  },
  getDefaultProps: function() {
    return {
      required: false,
    }
  },
  classNameForInput: function(){
    var classes = {
      "filebutton": "input-file",
      "textarea": "input-textarea form-control", //wrong. double-check. http://getbootstrap.com/components/#input-groups says you can't use textarea in .input-group
      "select": "input-group-select",
      "text": "form-control",
      "checkbox": "input-checkbox"
    };
    return classes[this.props.inputType];
  },
  theInput: function(){
    if (this.props.inputType == "filebutton"){
      // TODO: Add accept='image/*' ??
      return ( <input name={this.props.name} value={this.props.value} className={this.classNameForInput()} type="file" onChange={this.props.handleChange} required={this.props.required}  disabled={this.props.disabled} /> );
    }
    else if (this.props.inputType == "text" || this.props.inputType == "hidden"){
      return ( <input name={this.props.name} value={this.props.value} className={this.classNameForInput()} type={this.props.inputType} onChange={this.props.handleChange} onBlur={this.props.handleBlur} required={this.props.required}  disabled={this.props.disabled} /> );
    }
    else if (this.props.inputType == "textarea"){
      return ( <textarea name={this.props.name} value={this.props.value} className={this.classNameForInput()} onChange={this.props.handleChange} onBlur={this.props.handleBlur} required={this.props.required}  disabled={this.props.disabled} /> );
    }
    else if (this.props.inputType == "checkbox"){
      return ( <input type="checkbox" name={this.props.name} checked={this.props.value} className={this.classNameForInput()} onChange={this.props.handleChange} required={this.props.required} disabled={this.props.disabled} /> );
    }
    else if (this.props.inputType == "select") {
      var selectOptions = this.props.selectOptions.map(function(option, index){
        return ( <option value={option.slug} key={this.props.name + '-' + index}>{option.name}</option>);
      }.bind(this));
      return ( 
        <select name={this.props.name} value={this.props.value} className="input-xlarge" onChange={this.props.handleChange} onBlur={this.props.handleBlur} disabled={this.props.disabled}>
          { selectOptions }
        </select>
      );
    }
  },

  render: function(){
    var hint = this.props.hint ? (<span className="hint">{this.props.hint}</span>) : "";

    if (this.props.inputType == "checkbox") {
      return (
        <div className="form_-x-checkbox">
          <label>
            {this.theInput()}
            <span className="form_-x-checkbox-text">{this.props.label} {hint}</span>
          </label>
        </div>);
    }

    return (
        <div className="form_-x-field">
          <label htmlFor={this.props.name}>{this.props.label} {hint}</label>
          {this.theInput()}
        </div>);
  }
});

/* A droppable zone for image files. Must send in handler(file) for when images are dropped and set image prop with that file from above. */
var ImageDropbox = React.createClass({
  getDefaultProps: function() {
    return {
      'hint': "Tap here to upload image",
    }
  },
  validateFileType: function(file){
    if (file instanceof File && (file.type && (file.type == 'image/png' || file.type == 'image/svg+xml')))
      return true;
  },
  fileHandler: function(files){
    file = files[0];
    if (this.validateFileType(file)){
      this.props.onDroppedImage(file);
    }
  },
  render: function() {
    var dropzoneStyle = {};
    return (
        <div className="form_-x-field">
            <Dropzone onDrop={this.fileHandler} style={dropzoneStyle} activeClassName='is-active' className={'dropzone_ dropzone_-secondary'+ (this.props.imageData ? ' dropzone_-is-uploaded' : '')} required={this.props.required}>
                {this.props.imageData ? <img src={this.props.imageData} /> : (<p>{this.props.hint}</p>)}
            </Dropzone>
        </div>
    );
  }
});


BasicAPIForm = React.createClass({
  getDefaultProps: function() {
    return {
      handleBadgeStudioClick: undefined
    }
  },
  getInitialState: function() {
    return FormStore.getFormState(this.props.formId);
  },
  componentDidMount: function() {
    FormStore.addListener('FORM_DATA_UPDATED_' + this.props.formId, this.handlePatch);
    if (this.props.submitImmediately)
      this.handleSubmit();
  },
  componentWillUnmount: function() {
    FormStore.removeListener('FORM_DATA_UPDATED_' + this.props.formId, this.handlePatch);
  },
  handleChange: function(event){
    //reject change unless form is ready
    if (this.isMounted() && this.state.actionState != "ready"){
      event.stopPropagation();
      event.preventDefault();
      return;
    }
    var change = {};

    // Update Store immediately for checkbox fields
    if (this.props.fieldsMeta[event.target.name].inputType == 'checkbox') {
      change[event.target.name] = (!_.get(this.state, event.target.name)) ? "on": false;
      FormActions.patchForm(this.props.formId, change);

      return;
    }

    change[event.target.name] = event.target.value;
    this.setState(change);
  },
  // When an input field is blurred, a form patch is submitted if its value has changed.
  // Does not apply to the image upload field
  handleBlur: function(event){
    var patch = {}
    var field = event.target.name;
    var currentValue = FormStore.getFieldValue(this.props.formId, field);
    if (currentValue !== event.target.value){
      patch[field] = event.target.value;
      FormActions.patchForm(this.props.formId, patch);
    }
  },
  // This catches the result from form update and applies it to the formstate. 
  // On submit, it is how the result gets displayed.
  handlePatch: function(){
    // this is bound...
    if (this.isMounted()){
      var newState = FormStore.getFormState(this.props.formId);
      this.setState(newState);
    }
  },
  handleSubmit: function(e){
    if (typeof e !== 'undefined'){
      e.preventDefault(); 
      e.stopPropagation();
    }
    
    if (this.state.actionState != "waiting")
      // TODO: Test submission via form control rather than Dialog SubmitButton
      FormActions.submitForm(this.props.formId, this.props.formType, this.state);
  },
  handleReset: function(e){
    e.preventDefault();
    e.stopPropagation();

    FormActions.resetForm(this.props.formId);
    if (this.props.handleCloseForm){
      this.props.handleCloseForm();
    }
  },
  handleImageDrop: function(file){
    // To make sure any changes within the focused element are recorded in the form state
    document.activeElement.blur();

    var reader = new FileReader();
    reader.onload = function(e) {
      if (this.isMounted()){
        FormActions.patchForm(this.props.formId, { image: file, imageData: reader.result });
      }
    }.bind(this);
    reader.readAsDataURL(file);

  },
  render: function() {
    var messageText = _.get(this.state, 'message.content'),
        messageDescription = (_.get(this.state.message, 'detail.detail')) ? (<p>{_.get(this.state.message, 'detail.detail')}</p>) : null;
        // TODO: Create pattern library modules for the different types of content that could be in this.state.message.detail
        messageDetail = (this.state.message && this.state.message.detail) ? (
            <div className='message-x-detail'>
              <h4>{_.get(this.state.message, 'detail.message', JSON.stringify(this.state.message.detail))}</h4>
              {messageDescription}
            </div>
        ) : null;
    var activeColumns = "",
        activeMessage = (this.state.message) ? (<div className={"alert alert-" + this.state.message.type}>
          {messageText}
          {messageDetail}
        </div>) : "",
        activeHelpText = !this.state.message && this.props.helpText ? <div className="form-help-text">{this.props.helpText}</div> : "",
        formControls = "",
        closeButton = this.props.handleCloseForm ? (<Button name="close" label="Cancel" style="secondary" handleClick={this.handleReset} />) : "",
        loadingIcon = this.state.actionState == "waiting" ? (
          <div className="form_-x-loaing loading_">
            <p>Saving&hellip;</p>
          </div>) : "";

    if (["ready", "waiting"].indexOf(this.state.actionState) > -1){

      activeColumns = this.props.columns.map(function(item, i){
        var thisColumnItems = item.fields.map(function(fieldKey, j){
          var value = this.state[fieldKey];
          var fieldProps = this.props.fieldsMeta[fieldKey];
          var inputType = fieldProps.inputType;

          if (inputType == 'image'){
            var badgeStudioButton;
            if (this.props.handleBadgeStudioClick) {
              var badgeStudioButton = (
              <div>
                <div className="form_-x-field">
                    <p>Or</p>
                </div>
                <div className="form_-x-field">
                    <button type="button" onClick={this.props.handleBadgeStudioClick} className="button_ button_-tertiary">Use Badge Studio</button>
                </div>
              </div>);
            }
            return (
              <div>
                <div className="form_-x-field" key={this.props.formId + "-form-field-" + i + '-' + j}>
                  <ImageDropbox
                    onDroppedImage={this.handleImageDrop}
                    image={this.state.image}
                    imageData={this.state.imageData}
                    imageDescription={this.props.formType == "IssuerCreateUpdateForm" ? "Image": "Badge"}
                    {...fieldProps}
                  />
                </div>
                {badgeStudioButton}
              </div>
            );
          }
          else if (inputType == 'select'){
            return (
              <InputGroup name={fieldKey} key={this.props.formId + "-form-field-" + i + '-' + j}
                selectOptions={fieldProps.selectOptions}
                value={value} 
                handleChange={this.handleChange}
                handleBlur={this.handleBlur}
                {...fieldProps}
              />
            );
          }
          else if (inputType == 'checkbox'){
            return (
              <InputGroup name={fieldKey} key={this.props.formId + "-form-field-" + i + '-' + j}
                value={value} 
                handleChange={this.handleChange}
                handleBlur={this.handleBlur}
                {...fieldProps}
              />
            );
          }
          else if (["text", "hidden", "textarea"].indexOf(inputType) > -1) {
            // for input types 'text', 'textarea'
            return (
              <InputGroup name={fieldKey} 
                key={this.props.formId + "-form-field-" + i + '-' + j}
                value={value}
                handleChange={this.handleChange} 
                handleBlur={this.handleBlur}
                {...fieldProps}
              />
            );
          }
          else if (inputType == 'divider'){
            return (<p className="divider" key={"divider-" + i}><strong>{fieldProps.label}</strong></p>);
          }
        }.bind(this));
        return (
          <fieldset className={item.className} key={this.props.formId + "-form-column-" + i}>
            {thisColumnItems}
          </fieldset>
        );
      }.bind(this));
      formControls = (
        <div className="control_">
          {closeButton}
          <Button type="submit" name="submit" label={_.get(this.props, 'formControls.submit.label', 'Submit')} handleClick={this.handleSubmit} />
          {loadingIcon}
        </div>
      );
    }
    else {
      formControls = (
        <div className="control_">
          {closeButton}
        </div>
      );
    }

    if (this.props.hideFormControls) {
      formControls = "";
    }

    if (this.state.actionState == "waiting") {
      activeMessage = "";
      activeHelpText = "";
    }

    return (
      <div className="form-container issuer-notification-form-container">
        {activeMessage} {activeHelpText}
        {loadingIcon}
        <form action="" className={"form_ "+(this.state.actionState == "waiting" ? " form_-is-submitted " : "")} onSubmit={this.handleSubmit}>
          <div className="form_-x-imageupload">
            {activeColumns}
          </div>
          {formControls}
        </form>
      </div>);
  }
});


// Export the Menu class for rendering:
module.exports.BasicAPIForm = BasicAPIForm;
