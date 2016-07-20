var QuestionIndex = {

  initialize: function(){
    $('.question-section').css("height", (document.body.clientHeight-100)+"px")
    var questionItemHeight = (document.body.clientHeight-100)/3;
    $('.question-section .question-item').css("height", (questionItemHeight)+"px")
  }
};

$(function(){
  QuestionIndex.initialize();
});