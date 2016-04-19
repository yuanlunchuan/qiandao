//= require shared/jquery.touchSwipe.min.js
$(document).ready(function(){
  var event_id = $('#event-id').data('event-id');
  $.getJSON(
    '/client/events/'+event_id+'/event_info.json',
    {},
    function(result) {//返回数据根据结果进行相应的处理
      if ( result.success ) {
        if (result.collection[0].display_welcome_page == false) {
          location.href="/client/sessions/new"
        };
        if (result.collection[0].welcome_page_logo) {
          $('.logo-area img').attr("src",result.collection[0].welcome_page_logo);
        };
        if (result.collection[0].welcome_bg) {
          $('.home-bg img').attr("src",result.collection[0].welcome_bg);
        };
        if (result.collection[0].opposite_color == false) {
          $('.container').addClass("font-white");
        }
        else{
          $('.container').removeClass("font-white");
        }
      }
      else {
        alert("请求失败了")
      }
    }
  )
  $("#page0").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "up")
      {
        $("#page0").css("display","none");
        $("#page1").css("display","block");
        $('#page0').addClass("fadeInDown")
      };
    },
  });
  $("#page1").swipe({ 
    swipe:function(event,direction, distance, duration, fingerCount)
    {
      if (direction == "down")
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
    },800);
  });
})
