var Obj = {
  choosed_attendee: [],
  total_attendee: 0,

  onAttendeeIdBoxClicked: function(event){
    var self = Obj;
    self.remove($(this).data('attendee-id'));
    $(this).remove();
  },

  remove: function(val){
    var self = Obj;
    var index = self.indexOf(val);
    if (index > -1) {
      self.choosed_attendee.splice(index, 1);
    }
  },

  indexOf: function(val){
    var self = Obj;
     for (var i = 0; i < self.choosed_attendee.length; i++) {
        if (self.choosed_attendee[i] == val) return i;
      }
      return -1;
  },

  initialize: function(){
    var self = Obj;
    var table_col = 1;

    self.total_attendee = $('#per-table-num').data('per-table-num')-$('#seat-table').data('attendee-count');

    $('#save-and-continue').on('click', function(){
      if (!self.choosed_attendee.length) {
        alert('请选择嘉宾');
        return;
      }
      var arrange_seat_url = '/app/events/'+$('#current-event').data('current-event')+'/arrange_seat.json?';
      for(var i=0; i< self.choosed_attendee.length; i++)
      {
        arrange_seat_url = arrange_seat_url+'&attendees_id[]='+self.choosed_attendee[i]
      }

      var session_id = $('#current-session-id').data('current-session-id');
      $.getJSON(arrange_seat_url,
        {
          session_id: session_id,
          table_row: $('#current-row').data('current-row')
        },
        function(event){
          window.location.href='/app/events/'+$('#current-event').data('current-event')+'/seats/new?current_action=show_attendees&session_id='+session_id;
        });
    });

    $('#wait-arrange-seat-attendee tr').each(function(){
      $(this).on("click", function(event){
        var dele_attendee_seat_url = '/app/events/'+$('#current-event').data('current-event')+'/dele_attendee_seat.json?';
        $.post(dele_attendee_seat_url, 
          {
            session_id: $('#current-session-id').data('current-session-id'),
            attendee_id: $(this).children().eq(1).text()
          },function(event){
            window.location.href=window.location.href;
          }
          ).error(function(event){
            window.location.href=window.location.href;
          });
      });
    });

    $("#attendee-table tr").each(function(){
      $(this).on("click", function(event){
        if(self.total_attendee<=self.choosed_attendee.length){
          alert('已经坐满');
          return;
        }
        self.choosed_attendee.push($(this).children().eq(9).text());

        var attendee_name = $(this).children().eq(1).text();
        $(this).closest('tr').remove();
        var tr = "<tr><td class='attendee-id' data-attendee-id="+$(this).children().eq(9).text()+" align='center' valign='middle'>"+table_col+"<span style='border:1px solid #000; width: 100%'>"+attendee_name
        +"<i class='fa fa-times'></i></span></td></tr>"

        $('#wait-arrange-seat-attendee').append(tr);
        $('.attendee-id').on('click', self.onAttendeeIdBoxClicked);
        table_col++;
      });
    });
  }
};

$(window.document).ready(
  function(event)
  {
    Obj.initialize();
  }
);
