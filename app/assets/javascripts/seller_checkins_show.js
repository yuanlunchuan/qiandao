$(document).ready(function(){
  var session_id = $('#session-id').data('session-id');
  var url = '/seller/events/'+$('#event-id').data('event-id')+'/sessions/'+session_id+'/checkins.json?state=checked';

  if(!isNaN(parseInt(session_id))){
    url = url+'&session_id='+session_id
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
    var headItem = "<th>姓名</th><th>公司</th><th>签到时间</th><th>电话</th>";
    $('#attendee-table').append(headItem);

    $.each(event.collection, function(i, value) {
      if (event.size==(i+1)) {
        $('#checked_in_numbers').text(value.checked_in_numbers);
        $('#unchecked_in_numbers').text(value.unchecked_in_numbers);
        return;
      }
      var company = value.company ? value.company : '公司未知';
      var checkin_time = value.has_checked ? value.checked_in_at : '未签到';
      var tableItem = "<tr><td>"+value.name+"</td><td>"+company+"</td><td>"+checkin_time+"<td class='phone-button'><a href='tel:"+value.mobile+"'><span>一键拨号</span></a></td>";
      $('#attendee-table').append(tableItem);
    });
  }

  function loadAttendeeError(event){
    console.info("---------error event: "+JSON.stringify(event));
  }

  $('#checked_attendee').click(function(event){
    $('#checked_attendee button').removeClass('sign-active');
    $('#checked_attendee button').addClass('unsign-active');
    $('#not_checked_attendee button').removeClass('unsign-active');
    $('#not_checked_attendee button').addClass('sign-active');

    var session_id = $("#select-session-checkin").val();
    !session_id&&(session_id=$('#session-id').data('session-id'));
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/sessions/'+session_id+'/checkins.json?state=checked';

    if(!isNaN(parseInt(session_id))){
      url = url+'&session_id='+session_id;
    }
    loadAttendee(url);
  });

  $('#not_checked_attendee').click(function(event){
    $('#checked_attendee button').removeClass('unsign-active');
    $('#checked_attendee button').addClass('sign-active');
    $('#not_checked_attendee button').removeClass('sign-active');
    $('#not_checked_attendee button').addClass('unsign-active');

    var session_id = $("#select-session-checkin").val();
    !session_id&&(session_id=$('#session-id').data('session-id'));
    var url = '/seller/events/'+$('#event-id').data('event-id')+'/sessions/'+session_id+'/checkins.json?state=not_checked';

    if(!isNaN(parseInt(session_id))){
      url = url+'&session_id='+session_id;
    }

    loadAttendee(url);
  });

});
