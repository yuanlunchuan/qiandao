var Obj = {
  initialize: function(){
    var self = Obj;
    var table_col = 1;
    var arrange_seat_url = '/app/events/'+$('#current-event').data('current-event')+'/arrange_seat.json?'

    $('#save-and-continue').on('click', function(){
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
        arrange_seat_url = arrange_seat_url+"&attendees_id[]="+$(this).children().eq(9).text();
        var attendee_name = $(this).children().eq(1).text();
        $(this).closest('tr').remove();
        var tr = "<tr><td align='center' valign='middle'>"+table_col+"<span style='border:1px solid #000'>"+attendee_name
        +"<i class='fa fa-times'></i></span></td></tr>"
        $('#wait-arrange-seat-attendee').append(tr);
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
