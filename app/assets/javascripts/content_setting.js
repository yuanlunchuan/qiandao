var Obj = {
	onQrcodeButtonClicked: function(event){
    var self = Obj;
    $(".selector").sortable("destroy");
	},

	onRemoveSessionButtonClicked: function(event){
		var self = Obj;
	},

	onRemoveResturantButtonClicked: function(event){
		var self = Obj;
	},

  onRemoveRecomandButtonClicked: function(event){
  	var self = Obj;
  },

  onRemoveSeatButtonClicked: function(event){
    var self = Obj;
  },
  onRemoveOutSiteLinkClicked: function(event){
    var self = Obj;
  },

  onRemoveQuestionButtonClicked: function(event){
  	var self = Obj;
  },

  onRemoveLotteryPrizeButtonClicked: function(event){
  	var self = Obj;
  },

  //deal with sortable
  onSortableChanged: function(event, ui) {
    var self = Obj;
  },

  initialize: function(){
  	var self = Obj;

  	$('#qrcode-button').on('click', self.onQrcodeButtonClicked);
  	$('#remove-session').on('click', self.onRemoveSessionButtonClicked);
  	$('#remove-resturant').on('click', self.onRemoveResturantButtonClicked);
  	$('#remove-recommand').on('click', self.onRemoveRecomandButtonClicked);
  	$('#remove-seat').on('click', self.onRemoveSeatButtonClicked);
  	$('#outsite-link').on('click', self.onRemoveOutSiteLinkClicked);
  	$('#remove-question').on('click', self.onRemoveQuestionButtonClicked);
  	$('#lottery-prize').on('click', self.onRemoveLotteryPrizeButtonClicked);
  	$("#sortable").on("sortchange", self.onSortableChanged);
  }
};

$(function() {
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  Obj.initialize();
});
