var QuestionIndex = {
  count_time: 0,
  interval: null,

  initialize: function(){
    var self = QuestionIndex;
    $('.question-section').css("height", (document.body.clientHeight-100)+"px")
    var questionItemHeight = (document.body.clientHeight-100)/3;
    $('.question-section .question-item').css("height", (questionItemHeight)+"px")
    window.clearInterval(self.interval);
    self.interval = setInterval(self.refresh, 10000)
  },

  refresh: function(){
    var self = QuestionIndex;
    self.count_time += 1;
    location.reload();
  }
};

$(function(){
  QuestionIndex.initialize();
});