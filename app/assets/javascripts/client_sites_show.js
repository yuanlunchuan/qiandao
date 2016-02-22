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

  //生成二维码
  $(function(){
    var qrcode = new QRCode($("#qrcode")[0], {
      width : 120,//设置宽高
      height : 120
    });
    var qrcode_value = $('#attendee-token').data('attendee-token')
    qrcode.makeCode(qrcode_value);
  });

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
          var table_row = result.collection[0].table_row;
          var table_col = result.collection[0].table_col;
          var seat_message = "第"+table_row+"桌, 第"+table_col+"号";
          if (result.collection[0].properties) {
            if ('false'==result.collection[0].properties.set_table_num) {
              seat_message = "第"+table_row+"桌";
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
