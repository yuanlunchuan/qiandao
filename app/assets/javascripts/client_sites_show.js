$(document).ready(function(){
  $(function() {
    //计算表格应该自适应的高度
    var height = $(window).height()-$('.all-page').height();
    //设置每一行的高度
    $('.function-area tr').height(height/2);
  });
})