//= require shared/jquery.touchSwipe.min.js
$(document).ready(function(){
  $("#page0").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "down")
      {
        $("#page0").css("display","none");
        $("#page1").css("display","block");
      };
    },
  });
  $("#page1").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "up")
      {
        $("#page1").css("display","none");
        $("#page0").css("display","block");
      }
    },
  });
  $(function() {
    setInterval(function(){
      var bottom = $('.double-down').css("bottom");
      if(bottom == "40px")
      {
        $('.double-down').animate({bottom:"10px"});
      }
      else if (bottom == "10px")
      {
        $('.double-down').animate({bottom:"40px"});
      }
    },500);
  });
})
