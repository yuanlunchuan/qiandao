var Obj = {
  choosed_attendee: [],

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

    $('#save-and-continue').on('click', function(){
      var arrange_seat_url = '/app/events/'+$('#current-event').data('current-event')+'/arrange_seat.json?'
      for(var i=0; i< self.choosed_attendee.length; i++)
      {
        arrange_seat_url = arrange_seat_url+'&attendees_id[]='+self.choosed_attendee[i]
      }
      console.info(arrange_seat_url);
      return
      $.getJSON(arrange_seat_url,
        {
          session_id: $('#current-session-id').data('current-session-id'),
          table_row: $('#current-row').data('current-row')
        },
        function(event){
          window.location.href=window.location.href;
        });
    });

    $("#attendee-table tr").each(function(){
      $(this).on("click", function(event){
        self.choosed_attendee.push($(this).children().eq(9).text());

        var attendee_name = $(this).children().eq(1).text();
        $(this).closest('tr').remove();
        var tr = "<tr><td class='attendee-id' data-attendee-id="+$(this).children().eq(9).text()+" align='center' valign='middle'>"+table_col+"<span style='border:1px solid #000;>"+attendee_name
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
