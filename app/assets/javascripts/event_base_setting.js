//= require shared/jquery.hotkeys
//= require shared/bootstrap-wysiwyg
//= require shared/event_base_setting_rich_editor
//= require_self

$(window.document).ready(
  function(event)
  {
    RichEditor.initialize(
      {
        editorSelector:       '#rich-editor',
        fieldSelector:        'textarea#event_content',
        submitButtonSelector: 'button[type=submit]'
      }
    );
  }
);