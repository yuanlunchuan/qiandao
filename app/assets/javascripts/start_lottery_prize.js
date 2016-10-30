var StartLotteryPrize = {
  imageIndex: 0,
  timer: null,
  images: [],
  attendee_names: [],
  attendee_companies: [],
  attendee_ids: [],

  postLotteryPrize: function(attendee_id){
    var self = StartLotteryPrize;
    var event_id = $('#event').data('event-id');
    var event_lottery_prize_id = $('#event-lottery-prize').data('event-lottery-prize-id');

    var url = "/app/events/"+event_id+"/event_lottery_prizes/"+event_lottery_prize_id+"/lottery_prizes.json";

    $.post(url,
    {
      attendee_id: attendee_id,
      event_lottery_prize_item_id: $('#lottery-prize-item').val()
    },
    self.onPostLotteryPrizeSuccess).error(self.onPostLotteryPrizeFailure);
  },

  onPostLotteryPrizeFailure: function(event){
    alert('error');
  },

  onPostLotteryPrizeSuccess: function(event){
    var self = StartLotteryPrize;
    $('#lottery-prize-attendee-size').text(parseInt($('#lottery-prize-attendee-size').text())+1);

    var $tr=$("#lottery-prize-attendees tr").eq(0);
    var trHtml = "<tr class='last-person'><td><div class='number-area'>"+event.attendee.id+"</div>"
    +"</td><td><img src="+event.attendee.img_url+" class='name-icon attendee-avatar'"
    +"</td><td>"
    +event.attendee.name
    +"</td><td>"
    +event.event_lottery_prize_item.name+"<i class='fa fa-times' aria-hidden='true'></i>"
    +"</td></tr>";
    
    $tr.after(trHtml);
  },

  showPicture: function(imgUrl){
    var self = StartLotteryPrize;

    if(self.imageIndex == self.images.length)
    {
      clearInterval(self.timer);
      self.postLotteryPrize(self.attendee_ids[self.imageIndex-1]);
      self.imageIndex = 0;
      return;
    }
    $('#attendee-img').attr('src', self.images[self.imageIndex]);
    $('#attendee-name').text(self.attendee_names[self.imageIndex]);
    $('#attendee-company').text(self.attendee_companies[self.imageIndex]||'');

    self.imageIndex += 1;
  },

  loadAttendee: function(){
    var self = StartLotteryPrize;

    var event_id = $('#event').data('event-id');
    var event_lottery_prize_id = $('#event-lottery-prize').data('event-lottery-prize-id');
    $.getJSON('/app/events/'+event_id+'/event_lottery_prizes/'+event_lottery_prize_id+'/get_attendee_list.json',
      {
        lottery_prize_item: $('#lottery-prize-item').val()
      },
      function(event){
        self.images.length = 0;
        self.attendee_names.length = 0;
        self.attendee_companies.length = 0;
        self.attendee_ids.length = 0;
        $.each(event.collection, function(index, item){
          self.images.push(item.img_url);
          self.attendee_names.push(item.name);
          self.attendee_companies.push(item.company);
          self.attendee_ids.push(item.id);
        });
        self.timer = setInterval(self.showPicture,300);
    });
  },

  onStartLotteryPrizeClicked: function(){
    var self = StartLotteryPrize;
    self.loadAttendee();
  },

  initialize: function(){
    var self = StartLotteryPrize;
    $('#start-lottery-prize').on('click', self.onStartLotteryPrizeClicked);
  }
}
$(function(){
  StartLotteryPrize.initialize();
});
