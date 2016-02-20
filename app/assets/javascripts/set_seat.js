var Obj = {
  onLoadSeatSuccess: function(event){
    var self = Obj;
    var seat = event.collection[0];
    var sessionId = $('#session_id').val();
    $('#total-table-count').val(seat.total_table_count);
    $('#per-table-num').val(seat.per_table_num);
    if ('row'==seat.properties.unit) {
      $("#unit").val("row");
    }else{
      $("#unit").val("table");
    }
    if('true'==seat.properties.set_table_num){
      $("#show-table-num").attr('checked', 'checked');
    }else{
      $("#hide-table-num").attr('checked', 'checked');
    }
    $("#display-by-seat").attr('href', '/app/events/'+$('#current-event').data('current-event')+'/seats?display_type=seat&session_id='+sessionId);
    $("#display-by-attendee").attr('href', '/app/events/'+$('#current-event').data('current-event')+'/seats?display_type=attendee&session_id='+sessionId);
    $('#dispaly-seat').show();
    return self;
  },

  onLoadFailure: function(event){
    var self = Obj;
    $('#dispaly-seat').hide();

    $('#total-table-count').val('');
    $('#per-table-num').val('');
    $("#unit").val("row");
    $("#show-table-num").attr('checked', 'checked');
    return self;
  },

  loadSeat: function(){
    var self = Obj;
    var sessionId = $('#session_id').val();
    $.getJSON('/app/events/'+$('#current-event').data('current-event')+'/get_session_seat.json',
      {
        session_id: sessionId
      }, self.onLoadSeatSuccess).error(self.onLoadFailure);
    return self;
  },

  onSessionIdChanged: function(event){
    var self = Obj;
    console.info('--------line 30');
    self.loadSeat();
    console.info('-------line 32');
    return self;
  },

  initialize: function(){
    var self = Obj;
    self.loadSeat();
    $('#session_id').on('change', self.onSessionIdChanged);
  }
};

$(window.document).ready(
  function(event)
  {
    Obj.initialize();
  }
);
