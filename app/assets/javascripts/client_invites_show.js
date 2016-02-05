//= require shared/jquery.touchSwipe.min.js
$(document).ready(function(){
  $("#page0").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "down")
      {
        $("#page0").fadeOut();
        $("#page1").fadeIn();
      };
    },
  });
  $("#page1").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "up")
      {
        $("#page1").fadeOut();
        $("#page0").fadeIn();
      }
    },
  });
})
$(function() {
    setInterval(function(){
      var bottom = $('.double-down').css("bottom");
      if(bottom == "40px")
      {
        $('.double-down').animate({bottom:"10px"},1000);
      }
      else if (bottom == "10px")
      {
        $('.double-down').animate({bottom:"40px"},1000);
      }
    },100);
  });