var Obj = {
  clickCount: 0,
  old_seat_id: 0,
  oldObj: null,

  onSeatClicked: function(event){
    var self = Obj;
    
    self.old_seat_id++;
    if (self.old_seat_id%2) {
      self.old_seat_id = $('this').data('seat-id');
    }
    else{
      alert("old_seat_id: "+self.old_seat_id+"---new: "+$('this').data('seat-id'));
    }
  },

  initialize: function(){
    var self = Obj;

    $('.seat').click(function(){
      self.clickCount++;
      if (self.clickCount%2) {
        self.oldObj = $(this);
        self.old_seat_id = $(this).data('seat-id');
      }
      else{
        var temp = self.oldObj.text();
        self.oldObj.text($(this).text());
        $(this).text(temp);

        $.ajax({
          url: '/app/events/1/seats/1.json',
          type: 'PATCH',
          data: {
            first_seat: self.old_seat_id,
            second_seat: $(this).data('seat-id')
          }},
          function(event){
          }).error(function(event){
            alert('-----error');
        });
      } 
    });
  }
};

$(window.document).ready(
  function(event)
  {
    Obj.initialize();
  }
);
