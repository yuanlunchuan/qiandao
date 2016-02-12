$(document).ready(function(){
  $('.sign-area div').click(function(){
    $('.sign-area div').removeClass('sign-active');
    $(this).addClass('sign-active');
  });

  $('#all_attendee').click(function(event){
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/checkins.json';
    var session_id = $("#select-session-checkin").val();

    if(!isNaN(parseInt(session_id))){
      url = url+'?session_id='+session_id;
    }
    loadAttendee(url);
  });

  var url = '/seller/events/'+$('#event-id').data('event-id')+'/checkins.json';
  var session_id = $("#select-session-checkin").val();

  if(!isNaN(parseInt(session_id))){
    url = url+'?session_id='+session_id
    loadAttendee(url);
  }

  $('#search-button').click(function(event){
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/checkins.json';
    var keyWord = $('#key_word').val();
    if(!isNaN(parseInt(session_id))){
      url = url+'?session_id='+session_id
    }
    if (keyWord) {
      url = url+'&key_word='+keyWord;
      loadAttendee(url);
    };
  });

  function loadAttendee(load_url){
    $.getJSON(
      load_url,
      {
      },
      loadAttendeeSuccess).
      error(loadAttendeeError);
  }

  function loadAttendeeSuccess(event){
    $('#attendee-table').empty();
    var headItem = "<th>姓名</th><th>公司</th><th>状态</th><th>一键拨号</th>";
    $('#attendee-table').append(headItem);

    $.each(event.collection, function(i, value) {
      if (event.size==(i+1)) {
        $('#checked_in_numbers').text(value.checked_in_numbers);
        $('#unchecked_in_numbers').text(value.unchecked_in_numbers);
        return;
      }
      var company = value.company ? value.company : '公司未知';
      var tableItem = "<tr><td>"+value.name+"</td><td>"+company+"</td><td>"+'已签到'+"</td><td>"+"<td class='phone-button'><a href='tel:10086'><span>一键拨号</span></a></td>";
      $('#attendee-table').append(tableItem);
    });
  }

  function loadAttendeeError(event){
    console.info("---------error event: "+JSON.stringify(event));
  }

  $('#checked_attendee').click(function(event){
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/checkins.json?state=checked';

    var session_id = $("#select-session-checkin").val();
    if(!isNaN(parseInt(session_id))){
      url = url+'&session_id='+session_id;
    }
    loadAttendee(url);
  });

  $('#not_checked_attendee').click(function(event){
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/checkins.json?state=not_checked';

    var session_id = $("#select-session-checkin").val();
    if(!isNaN(parseInt(session_id))){
      url = url+'&session_id='+session_id;
    }

    loadAttendee(url);
  });

});
