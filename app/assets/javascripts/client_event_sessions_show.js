$(document).ready(function(){
  $('.schedule-down').click(function(){
    var showIs = $(this).closest('.schedule-msg').find('.schedule-list').hasClass('hidden')
    if(showIs)
    {
      $(this).closest('.schedule-msg').find('.schedule-list').removeClass('hidden');
    }
    else
    {
      $(this).closest('.schedule-msg').find('.schedule-list').addClass('hidden');
    }
  })
})