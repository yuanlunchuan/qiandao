$(document).ready(function(){
  $('.sign-area div').click(function(){
    $('.sign-area div').removeClass('sign-active');
    $(this).addClass('sign-active');
  });

  $('#all_attendee').click(function(event){
    $.getJSON('/seller/checkins.json');
  });

  $('#checked_attendee').click(function(event){

  });

  $('#not_checked_attendee').click(function(event){

  });

});
