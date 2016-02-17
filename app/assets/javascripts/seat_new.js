var Obj = {
  initialize: function(){
    var self = Obj;

    $("#attendee-table tr").each(function(){
      $(this).on("click", function(event){
        var attendee_name = $(this).children().eq(1).text();
        $(this).closest('tr').remove();
        var tr = "<tr><td align='center' valign='middle'>"+attendee_name+"</td></tr>"
        $('#wait-arrange-seat-attendee').append(tr);
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
