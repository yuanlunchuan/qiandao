var Obj = {
	onQrcodeButtonClicked: function(event){
    var self = Obj;
    $(this).parent().remove();
	},

	onRemoveSessionButtonClicked: function(event){
		var self = Obj;
    $(this).parent().remove();
	},

	onRemoveResturantButtonClicked: function(event){
		var self = Obj;
    $(this).parent().remove();
	},

  onRemoveRecomandButtonClicked: function(event){
  	var self = Obj;
    $(this).parent().remove();
  },

  onRemoveSeatButtonClicked: function(event){
    var self = Obj;
    $(this).parent().remove();
  },
  onRemoveOutSiteLinkClicked: function(event){
    var self = Obj;
    $(this).parent().remove();
  },

  onRemoveQuestionButtonClicked: function(event){
  	var self = Obj;
    $(this).parent().remove();
  },

  onRemoveLotteryPrizeButtonClicked: function(event){
  	var self = Obj;
    $(this).parent().remove();
  },

  onSaveFunctionOrderClicked: function(event){
    var self = Obj;
    $('li').each(function(){
      $(this).data('function-name')&&console.info("-------------function name: "+$(this).data('function-name'));
    });
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
    $('#saveFunctionOrder').on('click', self.onSaveFunctionOrderClicked);
  }
};

$(function() {
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  Obj.initialize();
});
