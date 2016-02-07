$(document).ready(function(){

  $(function(){
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
  });

  $(function(){
    var qrcode = new QRCode($("#qrcode")[0], {
      width : 120,//设置宽高
      height : 120
    });
    qrcode.makeCode("https://www.baidu.com");
  });

  //显示二维码
  $('.voucher-button').click(function(){
    $('.page0').addClass("blur");
    $('.voucher-page').removeClass("hidden");
  });

  //隐藏二维码
  $('.voucher-page').click(function(){
    $('.page0').removeClass("blur");
    $('.voucher-page').addClass("hidden");
  });
  //显示座位
  $('.seat-button').click(function(){
    $('.page0').addClass("blur");
    $('.seat-page').removeClass("hidden");

    setTimeout("$('.seat-number').html('第 12 桌')",1200);
  });

  //隐藏座位
  $('.seat-page').click(function(){
    $('.page0').removeClass("blur");
    $('.seat-page').addClass("hidden");
  });

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
})