$(document).ready(function(){
  var ua = navigator.userAgent.toLowerCase();
  if(ua.match("applewebkit")&&ua.match(/MicroMessenger/i)=="micromessenger"){
    $('#down-load-info').text('长按保存二维码');
  }

  //图片异步上传
  $(".dropz").dropzone({
    url: "/client/events/"+$('#event-id').data('event-id')+"/upload_photo?id="+$('#attendee-id').data('attendee-id'),
    dictRemoveLinks: "x",
    dictCancelUpload: "x",
    maxFiles: 10,
    maxFilesize: 5,
    acceptedFiles: "image/*",
    init: function() {
      this.on("success", function(file) {
      //attendee_photo
        console.log("File " + JSON.stringify(file) + "uploaded");
      });
      this.on("removedfile", function(file) {
          console.log("File " + file.name + "removed");
      });
    }
  });

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
          var notice = result.collection[0].content;
          if(notice != null){
            $('.notice-msg').html(notice);
          }
        } else {
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
    var qrcode_value = $('#rfid-num').data('rfid-num')
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
          var table_row = result.collection[0].table_row
          var table_col = result.collection[0].table_col
          $('.seat-number').html("第"+table_row+"桌, 第"+table_col+"号");
        } else {
          alert("请求失败了")
        }
      }
    )
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
      var fr = new FileReader();
      fr.onloadend = function(e)
      {
        $('.portrait-img').attr({'src':e.target.result});
      };
      fr.readAsDataURL(file);
    }
  });
});
