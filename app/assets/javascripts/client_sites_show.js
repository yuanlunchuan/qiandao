$(document).ready(function(){
  var ua = navigator.userAgent.toLowerCase();
  if(ua.match("applewebkit")&&ua.match(/MicroMessenger/i)=="micromessenger"){
    $('#down-load-info').text('长按保存二维码');
  }

  setTimeout(function(){
    $('.load-page').fadeOut();
    $('.home-page').fadeIn();

    if($('.illus-area').height()== 1)//网路差图片还没加载出来
    {
      var img_height = parseInt(($(window).width()/496)*228);//计算图片的高度
      var height = $(window).height()-$('.all-page').height()-img_height;
    }
    else
    {
      var height = $(window).height()-$('.all-page').height();
    }
    //设置每一行的高度
    $('.function-area tr').height((height-1)/2);

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
  },1000)
  //界面上显示哪些功能
  $(function(){
    var event_id = $('#event-id').data('event-id');
    $.getJSON(
      '/client/events/'+event_id+'/event_info.json',
      {},
      function(result) {//返回数据根据结果进行相应的处理
        if ( result.success ) {
          var functions = new Array();
          var collection = result.collection[0];
          //将数据保存下来
          //入场凭证
          if (collection.admission_certificate_order!=0) {
            functions[collection.admission_certificate_order-1] = "admission_certificate_order";
          };
          //会议日程
          if (collection.session_schedule_order!=0) {
            functions[collection.session_schedule_order-1] = "session_schedule_order";
          };
          //酒店信息
          if (collection.hotel_info_order!=0) {
            functions[collection.hotel_info_order-1] = "hotel_info_order";
          };
          //周边推荐
          if (collection.nearby_recommend_order!=0) {
            functions[collection.nearby_recommend_order-1] = "nearby_recommend_order";
          };
          //座位查询
          if (collection.seat_info_order!=0) {
            functions[collection.seat_info_order-1] = "seat_info_order";
          };
          //官方网站
          if (collection.outside_link_order!=0) {
            functions[collection.outside_link_order-1] = "outside_link_order";
          };
          //现场抽奖
          if (collection.interactive_answer_order!=0) {
            functions[collection.interactive_answer_order-1] = "interactive_answer_order";
          };
          //互动问答
          if (collection.lottery_order!=0) {
            functions[collection.lottery_order-1] = "lottery_order";
          };

          //先根据需要显示的数量布局
          var count = functions.length;
          alert(collection.hotel_info_order!=0);
          console.info(functions);
        }
        else {
          alert("请求失败了")
        }
      }
    )
  })
  

  //生成二维码
  // $(function(){
  //   var qrcode = new QRCode($("#qrcode")[0], {
  //     width : 120,//设置宽高
  //     height : 120
  //   });
  //   var qrcode_value = $('#attendee-token').data('attendee-token')
  //   qrcode.makeCode(qrcode_value);
  // });

  //显示二维码
  $('.voucher-button').click(function(){
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    if (userAgent.indexOf("Safari") > -1)
    {
      $(".down-msg").html("长按图片下载二维码");
    }
    $('.page0').addClass("blur");
    $('.voucher-page').removeClass("hidden");
  })

  //隐藏二维码
  $('.voucher-page').click(function(){

    $('.qrcode-content').click(function(){
      return false;  //点击在div内时直接退出函数,可以不隐藏页面
    })

    $('.page0').removeClass("blur");
    $('.voucher-page').addClass("hidden");
  });

  //显示座位
  $('.seat-button').click(function(){
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
