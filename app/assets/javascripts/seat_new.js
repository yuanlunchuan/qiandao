var Obj = {
  choosed_attendee: [],
  total_attendee: 0,
  table_col: 1,
  isInitialized: false,

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

  showAttendee: function(attendee){
    var self = Obj;

    var html = "";
    html += "<tr><td>"+attendee.attendee_number+"</td>";
    html += "<td id='attendee-name'>"+attendee.name+"</td>";
    html += "<td>"+(attendee.owner_attendee_name||'')+"</td>";
    html += "<td>"+(attendee.seller_name||'')+"</td>";
    html += "<td>"+attendee.province+"</td>";
    html += "<td>"+attendee.city+"</td>";
    html += "<td>"+attendee.company+"</td>";
    html += "<td>"+attendee.mobile+"</td>";
    html += "<td>"+(attendee.category_name||'')+"</td>";
    html += "<td class='hidden'>"+attendee.id+"</td></tr>"

    return html;
  },

  onAddAttendeeClicked: function(event){
    var self = Obj;

    if(self.total_attendee<=self.choosed_attendee.length){
      alert('已经坐满');
      return;
    }
    if (isNaN($(this).children().eq(9).text())) {
      return;
    }
    self.choosed_attendee.push($(this).children().eq(9).text());

    var attendee_name = $(this).children().eq(1).text();
    $(this).closest('tr').remove();
    var tr = "<tr><td class='attendee-id' data-attendee-id="+$(this).children().eq(9).text()+" align='center' valign='middle'>"+self.table_col+"<span style='border:1px solid #000; width: 100%'>"+attendee_name
    +"<i class='fa fa-times'></i></span></td></tr>"

    $('#wait-arrange-seat-attendee').append(tr);
    $('.attendee-id').on('click', self.onAttendeeIdBoxClicked);
    self.table_col++;
  },

  onSearchAttendeeSuccess: function(event){
    var self = Obj;
    $('#search-button').text('搜索');
    $('#search-button').removeClass('disabled');
    $("#page-box").addClass('hidden');
    if (!event.collection.length) {
      alert('搜索结果为空');
      return;
    }
    $("#attendee-table tbody").html("");
    $.each(event.collection, function(index, attendee){
      $("#attendee-table tbody").append(self.showAttendee(attendee));
    });
    $('#attendee-table tr').on('click', self.onAddAttendeeClicked);
  },

  onSearchButtonClicked: function(event){
    var self = Obj;
    if (!$('#keyword').val()) {
      return;
    }
    $('#search-button').text('请稍候');
    $('#search-button').addClass('disabled');
    $.getJSON('/app/events/'+$('#current-event').data('current-event')+'/search_attendees.json',
      {
        session_id: $('#current-session-id').data('current-session-id'),
        keyword: $('#keyword').val()
      },
      self.onSearchAttendeeSuccess
      ).error(function(event){
        $('#search-button').text('搜索');
        $('#search-button').removeClass('disabled');
        alert('搜索失败，请重试');
      });
  },

  onSaveAdnContinueButtonClicked: function(event){
    var self = Obj;
    if ($('#total-table-count').data('total-table-count')<$('#current-row').data('current-row')) {
      alert('当前已设置完所有桌');
      return;
    }
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
  },

  initialize: function(){
    var self = Obj;
    $('#search-button').on('click', self.onSearchButtonClicked);
    self.total_attendee = $('#per-table-num').data('per-table-num')-$('#seat-table').data('attendee-count');

    $('#save-and-continue').on('click', self.onSaveAdnContinueButtonClicked);

    $('#wait-arrange-seat-attendee tr').each(function(){
      $(this).on("click", function(event){
        var r=confirm("是否将该嘉宾移除?")
        if (r==false){
          return;
        }
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
    $("#attendee-table tr").on("click", self.onAddAttendeeClicked);
  }
};

$(window.document).ready(
  function(event)
  {
    //Obj.initialize();
  }
);
