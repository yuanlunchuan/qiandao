var clientQuestion = {
  currentElement: null,

  onPraiseButtonClicked: function(event){
    var self = clientQuestion;
    var question_id = $(this).data('question-id');
    self.currentElement = $(this);

    if ($(this).children('i').hasClass('gray-icon')) {
      self.sendRequest({
        question_id: question_id,
        action: 'cancel'
      });
      $(this).children('i').removeClass('gray-icon');
      $(this).children('i').addClass('red-icon');
      
    }else{
      self.sendRequest({
        question_id: question_id,
        action: 'praise'
      });
      $(this).children('i').removeClass('red-icon');
      $(this).children('i').addClass('gray-icon');
    }
  },

  sendRequest: function(data){
    var self = clientQuestion;

    var event_id = $('#event').data('event-id');
    var event_question_id = $('#event-question').data('event-question-id');
    var url = "/client/events/"+event_id+"/event_questions/"+event_question_id+"/praises.json"
    $.post(url, data, function(response){
      self.currentElement.children('.praise-count').text(response.praise_count);
    });
  },

  initialize: function(){
    var self = clientQuestion;

    $('.praise-button').on('click', self.onPraiseButtonClicked);
  }
};

$(function(){
  clientQuestion.initialize();
});
