$(document).ready(function(){
  var ua = navigator.userAgent.toLowerCase();
  if(ua.match("applewebkit")&&ua.match(/MicroMessenger/i)=="micromessenger"){
    $('#down-load-info').text('长按保存二维码');
  }
  var height;
  var result;
  var event_id = $('#event-id').data('event-id');
  $.getJSON(
    '/client/events/'+event_id+'/event_info.json',
    {},
    function(res) {//返回数据根据结果进行相应的处理
      if ( res.success ) {
        result = res;
        var collection = result.collection[0];
        //更换图片
        if (collection.head_photo!="/images/default-bg.png") {
          var img_height = $('.illus-area img').height();
          $(".illus-area img").attr("src",collection.head_photo);
          $(".illus-area img").height(img_height);
        }
      }
      else {
        alert("请求失败了")
      }
    }
  )
  setTimeout(function(){
    if($('.illus-area').height()== 1)//网路差图片还没加载出来
    {
      var img_height = parseInt(($(window).width()/496)*228);//计算图片的高度
      height = $(window).height()-$('.all-page').height()-img_height;
    }
    else
    {
      height = $(window).height()-$('.all-page').height();
    }
    //设置每一行的高度
    // $('.function-area tr').height((height-1)/2);

    //显示二维码(第一次打开)
    var showQrcodeIs = $('#show-qrcode').data('show-qrcode');
    if(showQrcodeIs){
      var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
      if (userAgent.indexOf("Safari") > -1)
      {
        $(".down-msg").html("长按图片下载二维码");
      }
      $('.page0').addClass("blur");
      $('.voucher-page').removeClass("hidden");
    }

    //请求通知消息
    var event_number = $('#event-id').data('event-id');
    $.getJSON(
      '/client/events/'+event_number+'/system_infos.json',
      {},
      function(result) {//返回数据根据结果进行相应的处理
        if ( result.success ) {
          var notice = result.collection;
          if(notice != null&&notice != undefined){
            $('.scroll-area').html("");
            $.each(notice, function(i, value) {
              $('.scroll-area').append('<span class="notice-msg">'+value.content+'</span>');
            })
          }
        }
        else {
          alert("请求失败了")
        }
      }
    )
    //界面上显示哪些功能
    if ( result.success ) {
      var functions = new Array();
      var collection = result.collection[0];
      //将数据保存下来
      //入场凭证
      if (collection.admission_certificate_order!=0) {
        functions[collection.admission_certificate_order-1] = "voucher";
      };
      //会议日程
      if (collection.session_schedule_order!=0) {
        functions[collection.session_schedule_order-1] = "schedule";
      };
      //酒店信息
      if (collection.hotel_info_order!=0) {
        functions[collection.hotel_info_order-1] = "hotel";
      };
      //周边推荐
      if (collection.nearby_recommend_order!=0) {
        functions[collection.nearby_recommend_order-1] = "periphery";
      };
      //座位查询
      if (collection.seat_info_order!=0) {
        functions[collection.seat_info_order-1] = "seat";
      };
      //官方网站
      if (collection.outside_link_order!=0) {
        functions[collection.outside_link_order-1] = "official_website";
      };
      //互动问答
      if (collection.interactive_answer_order!=0) {
        functions[collection.interactive_answer_order-1] = "answer";
      };
      //现场抽奖
      if (collection.lottery_order!=0) {
        functions[collection.lottery_order-1] = "lottery";
      };

      //先根据需要显示的数量布局以及高度
      var count = functions.length;
      setlayout(height,count,functions);
    }
    else {}
    $(".load-page").addClass("hidden");
  },1000)
  function setlayout(lay_height,count,functions){
    var x = 0; //横着有多少个元素
    var y = 0; //竖着有多少个元素
    if (count == 1||count == 2||count == 3) {
      y = 1;
    }
    if (count == 4) {
      x = 2;
    };
    if (count == 5||count == 6) {
      x = 3;
    };
    if (count == 7||count == 8) {
      x = 4;
    };
    //只有一排
    if(x == 0){
      $(".function-area tbody").empty();
      $(".function-area tbody").append("<tr>");
      for(var i = 0;i < count;i++){
        var value = setContent(functions[i]);//得到每格的内容
        $(".function-area tbody tr").append("<td>"+value+"</td>");
      }
      $('.function-area tr').height(height-2);
    }
    //有两排
    else{
      $(".function-area tbody").empty();
      $(".function-area tbody").append("<tr>");
      for(var i = 0;i < x;i++){
        var value = setContent(functions[i]);//得到每格的内容
        $(".function-area tbody tr").append("<td>"+value+"</td>");
      }
      //第二排
      $(".function-area tbody").append("<tr>");
      for(var i = x;i < count;i++){
        var value = setContent(functions[i]);//得到每格的内容
        $(".function-area tbody tr:eq(1)").append("<td>"+value+"</td>");//在第二个tr里添加内容
      }
      $('.function-area tr').height((height-1)/2);
    }
  }
  //设置每一个功能的值
  function setContent(content){
    if (content == "") {
      return " "
    };
    var event_id = $('#event-id').data('event-id');
    var event_link = $('#event-link').data('event-link');
    //会议日程
    if (content == "schedule") {
      return  "<a href='/client/events/"+event_id+"/event_sessions'>"+
              "<img src='/client/schedule.png' alt=''><span>会议日程</span>"+
              "</a>"
    };
    //入场凭证
    if (content == "voucher") {
      return  "<a href='javascript:void(0);' onclick='showQrcode()' class='voucher-button'>"+
              "<img src='/client/voucher.png' alt=''>"+
              "<span>入场凭证</span>"+
              "</a>"
    };
    //座位查询
    if (content == "seat") {
      return  "<a href='javascript:void(0);' onclick='showSeat()' class='seat-button'>"+
              "<img src='/client/seat.png' alt=''>"+
              "<span>座位查询</span>"+
              "</a>"
    };
    //酒店信息
    if (content == "hotel") {
      return  "<a href='/client/events/"+event_id+"/restaurants'>"+
              "<img src='/client/hotel.png' alt=''>"+
              "<span>酒店信息</span>"+
              "</a>"
    };
    //周边推荐
    if (content == "periphery") {
      return  "<a href='/client/events/"+event_id+"/recommends'>"+
              "<img src='/client/periphery.png' alt=''>"+
              "<span>周边推荐</span>"+
              "</a>"
    };
    //官方网站
    if (content == "official_website") {
      return  "<a href='"+event_link+"'>"+
              "<img src='/client/official.png' alt=''>"+
              "<span>官方网站</span>"+
              "</a>"
    };
    //互动问答
    if (content == "answer") {
      var current_event_question = $('#current_event_question').data('current-event-question');
      return  "<a href='/client/events/"+event_id+"/event_questions/"+current_event_question+"/questions'>"+
              "<img src='/client/answer.png' alt=''>"+
              "<span>互动问答</span>"+
              "</a>"
    };
    //现场抽奖
    if (content == "lottery") {
      return  "<a href='javascript:void(0);'>"+
              "<img src='/client/lottery.png' alt=''>"+
              "<span>现场抽奖</span>"+
              "</a>"
    };
  }

  //生成二维码
  // $(function(){
  //   var qrcode = new QRCode($("#qrcode")[0], {
  //     width : 120,//设置宽高
  //     height : 120
  //   });
  //   var qrcode_value = $('#attendee-token').data('attendee-token')
  //   qrcode.makeCode(qrcode_value);
  // });

  //隐藏二维码
  $('.voucher-page').click(function(){

    $('.qrcode-content').click(function(){
      return false;  //点击在div内时直接退出函数,可以不隐藏页面
    })

    $('.page0').removeClass("blur");
    $('.voucher-page').addClass("hidden");
  });

  //隐藏座位
  $('.seat-page').click(function(){

    $('.seat-show-area').click(function(){
      return false; //点击在div内时直接退出函数,可以不隐藏页面
    })

    $('.page0').removeClass("blur");
    $('.seat-page').addClass("hidden");
  });

  //上传图片
  $('#pic-portrait').change(function(){
    var file = $('#pic-portrait').prop('files')[0];
    if (!/image\/\w+/.test(file.type))
    {
      alert("请确保文件为图像类型");
      return false;
    }
    if (window.FileReader) 
    {
      $("#formId").submit();
    }
  });
});
//显示二维码
function showQrcode(){
  var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    if (userAgent.indexOf("Safari") > -1)
    {
      $(".down-msg").html("长按图片下载二维码");
    }
    $('.page0').addClass("blur");
    $('.voucher-page').removeClass("hidden");
}
//显示座位
function showSeat(){
  $('.page0').addClass("blur");
  $('.seat-page').removeClass("hidden");
  //请求座位
  var event_number = $('#event-id').data('event-id');
  var attendee_number = $('#attendee-id').data('attendee-id');
  $.getJSON(
    '/client/events/'+event_number+'/seats',
    {
      attendee_id:attendee_number,
    },
    function(result) {//返回数据根据结果进行相应的处理
      if ( result.success ) {
        var unit = '桌';
        var table_row = result.collection[0].table_row;
        var table_col = result.collection[0].table_col;

        if ('row'==result.collection[0].properties.unit) {
          unit = '排';
        }
        var seat_message = "第"+table_row+unit+", 第"+table_col+"号";

        if (result.collection[0].properties) {
          if ('false'==result.collection[0].properties.set_table_num) {
            seat_message = "第"+table_row+unit;
          }
        }
        $('.seat-number').html(seat_message);
      }
    }
  ).error(function(event){
    if ('404'==event.status) {
      $('.seat-number').html('正在安排中');
    }else{
      alert('网络请求失败， 请重试。');
    }
  });
}
