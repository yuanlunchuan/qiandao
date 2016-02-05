$(document).ready(function(){
  //计算表格应该自适应的高度
  var height = $(window).height()-$('.all-page').height();
    //设置每一行的高度
  alert("屏幕高度:"+$(window).height());
  alert("其他部分高度:"+$('.all-page').height());
  alert("实际的高度:"+(height-1)/2);
  $('.function-area tr').height((height-5)/2);
})