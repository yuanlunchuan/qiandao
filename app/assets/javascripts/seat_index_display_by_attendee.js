var SeatIndexDisplayByAttendee = {
  attendee_id: '',

  onUpdateSeatFailure: function(event){
    alert('安排失败');
  },

  onUpdateSeatSuccess: function(event){
    window.location.href=window.location.href;
  },

  updateSeat: function(){
    var self= SeatIndexDisplayByAttendee;

    var url = '/app/events/'+$('#current-event').data('current-event')+"/update_attendee_seat.json"
    $.post(url, 
      {
        table_row:   $("#table-row-num").val(),
        table_col:   $("#table-col").val(),
        attendee_id: self.attendee_id,
        session_id:  $('#session-id').data('session-id')
      },self.onUpdateSeatSuccess
      ).error(self.onUpdateSeatFailure);
  },

  onLoadTableColSuccess: function(event){
    var self = SeatIndexDisplayByAttendee;
    $('#table-col').empty();
    var per_table_num = event.collection[0].per_table_num;
    for(var i=1; i<= per_table_num; i++){
      var find = false;
      var optionValue = i;
      $.each(event.collection, function(col, item){
        if(!i){
          return;
        }
        if (i==item.table_col) {
          find = true;
        }
      });
      if (find) {
        optionValue = "第"+i+"号已占";
      };
      var optionItem = "<option value="+optionValue+">"+optionValue+"</option>";
      $('#table-col').append(optionItem);
    }
  },

  onLoadTableColFailure: function(event){
    var self = SeatIndexDisplayByAttendee;
    
  },

  showTableColList: function(table_row){
    var self = SeatIndexDisplayByAttendee;
    if (!$('#set-table-num').data('set-table-num')){
      return;
    }
    var url = '/app/events/'+$('#current-event').data('current-event')+"/search_by_session_row.json"
    $.getJSON(url, 
      {
        session_id: $('#session-id').data('session-id'),
        table_row: table_row
      },self.onLoadTableColSuccess).error(self.onLoadTableColFailure);
  },

  onTableRowChanged: function(event){
    var self = SeatIndexDisplayByAttendee;

    if (isNaN($(this).val())) {
      return;
    }
    self.showTableColList($(this).val());
  },

  onCancelButtonClicked: function(event){
    var self = SeatIndexDisplayByAttendee;
    window.location.href=window.location.href;
  },

  initialize: function(){
    var self = SeatIndexDisplayByAttendee;

    $('#cancel-button').on('click', self.onCancelButtonClicked);
    $("#seat-attendee-table tr #update-seat").each(function(){
      $(this).on("click", function(event){
        $('#cancel-button').removeClass('hidden');
        if('保存'==$(this).text())
        {
          if ($('#set-table-num').data('set-table-num')&&isNaN($("#table-col").val())) {
            alert('不能在已占座位上安排');
            return;
          }
          self.updateSeat();
          $(this).html("<button>变更</button>");
          return;
        }
        if (self.attendee_id) {
          alert('请先取消之前的操作');
          return;
        }
        self.attendee_id = $(this).parent().children().eq(8).text();
        $(this).html("<button>保存</button>");
        var val = $(this).parent().children().eq(6);

        var url = "/app/events/"+$('#current-event').data('current-event')+"/get_seats_tablerow.json";
        $.getJSON(url,
          {
            session_id: $('#session-id').data('session-id')
          },
          function(event){
            if (!event.collection.length) {
              alert('当前座位已安排完');
              return
            }
            val.empty();

            var table_row = "<select id='table-row-num'>";
            $.each(event.collection, function(item){
              table_row +="<option value='"+this+"'>"+this+"</option>";
            });

            if ($('#set-table-num').data('set-table-num')) {
              table_row = table_row+"</select>桌, <select id='table-col'>"+
              "<option value='choos'>请选择桌号</option></select>号";
            }else{
              table_row = table_row+"</select>桌";
            }

            val.html(table_row);
            $('#table-row-num').on('change', self.onTableRowChanged);
            self.showTableColList(1);
          });
      });
    });
  }
};

$(window.document).ready(
  function(event)
  {
    SeatIndexDisplayByAttendee.initialize();
  }
);
