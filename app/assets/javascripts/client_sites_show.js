$(document).ready(function(){

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
})