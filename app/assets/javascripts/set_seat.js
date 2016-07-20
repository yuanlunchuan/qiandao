  var setSeat = {
    onLoadSeatSuccess: function(event){
      var self = setSeat;
      var seat = event.collection[0];
      $('#set-seat').text('重新设置');
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
      $('#continue-arrange-seat').removeClass('hidden')
      $('#continue-arrange-seat').attr('href', '/app/events/'+$('#current-event').data('current-event')+'/seats/new?current_action=show_attendees&session_id='+sessionId)

      $('#dispaly-seat').show();
      return self;
    },

    onLoadFailure: function(event){
      var self = setSeat;
      $('#dispaly-seat').hide();
      $('#set-seat').text('开始设置');
      $('#total-table-count').val('');
      $('#per-table-num').val('');
      $("#unit").val("table");
      $('#continue-arrange-seat').addClass('hidden')
      $("#show-table-num").attr('checked', 'checked');
      return self;
    },

    loadSeat: function(){
      var self = setSeat;
      var sessionId = $('#session_id').val();
      $.getJSON('/app/events/'+$('#current-event').data('current-event')+'/get_session_seat.json',
        {
          session_id: sessionId
        }, self.onLoadSeatSuccess).error(self.onLoadFailure);
      return self;
    },

    onSessionIdChanged: function(event){
      var self = setSeat;
      self.loadSeat();
      return self;
    },

    initialize: function(){
      var self = setSeat;

      self.loadSeat();
      $('#session_id').on('change', self.onSessionIdChanged);
    }
  };

  $(window.document).ready(
    function(event)
    {
      setSeat.initialize();
    }
  );