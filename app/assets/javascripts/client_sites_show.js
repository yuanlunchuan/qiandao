//= require shared/jquery.touchSwipe.min.js
$(document).ready(function(){
  $(function() {
    setInterval(function(){
      var bottom = $('.double-down').css("bottom");
      if(bottom == "10px")
      {
        $('.double-down').animate({bottom:"50px"},1000);
      }
      else if (bottom == "50px") 
      {
        $('.double-down').animate({bottom:"10px"},1000);
      }
    },100);
  });
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
      else if(direction == "down")
      {
        $("#page1").fadeOut();
        $("#page2").fadeIn();
      }
    },
  });
  $("#page2").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "up")
      {
        $("#page2").fadeOut();
        $("#page1").fadeIn();
      };
    },
  });
  $(".phone-area input").keydown(function(event){
    var keyCode = event.which||event.keyCode;

    if(keyCode > 47&& keyCode < 58)
    {
      alert("yes");
    }
  });
})