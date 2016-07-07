var RichEditor = {

  richEditor:   null,
  field:        null,
  submitButton: null,

  initialize: function(options)
  {
    var self = RichEditor;
    self.richEditor   = $(options['editorSelector']||'#rich-editor');
    self.field        = $(options['fieldSelector']||'textarea.hidden');
    self.submitButton = $(options['submitButtonSelector']||'button[type=submit]');

    self.richEditor.wysiwyg();
    self.submitButton.on('click', self.onSubmitButtonClicked);
  },

  onSubmitButtonClicked: function(event)
  {
    var self = RichEditor;
    self.field.text(self.richEditor.text());
  }
};
