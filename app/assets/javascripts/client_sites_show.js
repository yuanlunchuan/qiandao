$(document).ready(function(){

  if($('.illus-area').height()== 1)//网路差图片还没加载出来
  {
    var img_height = $('.illus-area').height();
    var height = $(window).height()-$('.all-page').height()-img_height;
  }
  else
  {
    var height = $(window).height()-$('.all-page').height();
  }
  //设置每一行的高度
  $('.function-area tr').height((height-1)/2);
})