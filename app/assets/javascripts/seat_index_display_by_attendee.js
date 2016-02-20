var Obj = {
  updateSeat: function(){
    var self= Obj;

  },

  initialize: function(){
    var self = Obj;

    $("#seat-attendee-table tr #update-seat").each(function(){
      $(this).on("click", function(event){
        if('保存'==$(this).text())
        {
          self.updateSeat();
          $(this).html("<button>变更</button>");
          return;
        }
        $(this).html("<button>保存</button>");
        var val = $(this).parent().children().eq(6);
        val.empty();
        var url = "/app/events/"+$('#current-event').data('current-event')+"/get_seats_tablerow.json?session_id="+$('#session-id').data('session-id');
        $.getJSON(url,
          {},
          function(event){
          var table_row = "<select id='table-row' name='cars'>";
          $.each(event.collection, function(item){
            table_row +="<option value='"+this+"'>"+this+"</option>";
          });

          table_row = table_row+"</select>桌, <select name='cars'>"+
          "<option value='choos'>请选择桌号</option></select>号";
          val.html(table_row);
          });
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
