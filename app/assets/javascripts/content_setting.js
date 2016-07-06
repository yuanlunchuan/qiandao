var Obj = {
  functinList: [],

  onSaveFunctionOrderClicked: function(event){
    var self = Obj;
    var functionOrder = 0;
    var sendData = [];
    $('li').each(function(){
      var data = {};
      if($(this).data('function-name')){
        functionOrder += 1;
        data = {
          function_name: $(this).data('function-name'),
          function_order: functionOrder
        }
        sendData.push(data);
      }
    });
    self.updateEventFunctionOrder(sendData);
  },

  updateEventFunctionOrder: function(data){
    var self = Obj;
    var eventId = $("#event-id").data('event-id');
    $.post('/app/events/'+eventId+'/update_event_function_order.json',
      {
        function_list: data,
        function_length: data.length
      },
      function(event){
        event.collection.length==0&&$('#saveFunctionOrder').addClass('hidden');
        alert('success');
      });
  },

  onGetEventFunctionSuccess: function(event){
    var self = Obj;
    var currentEvent = event.collection[0];
    (currentEvent.admission_certificate||currentEvent.session_schedule||currentEvent.hotel_info||currentEvent.nearby_recommend||currentEvent.seat_info||currentEvent.outside_link||currentEvent.interactive_answer||currentEvent.lottery)&&$('#saveFunctionOrder').removeClass('hidden');
    if(self.functinList.length>0){
      return;
    }
    if (currentEvent.admission_certificate){
      var item = {
        functionName: 'admission_certificate',
        functionOrder: currentEvent.admission_certificate_order
        };
      self.functinList.push(item)
    }
    if (currentEvent.session_schedule){
      var item = {
        functionName: 'session_schedule',
        functionOrder: currentEvent.session_schedule_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.hotel_info){
      var item = {
        functionName: 'hotel_info',
        functionOrder: currentEvent.hotel_info_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.nearby_recommend){
      var item = {
        functionName: 'nearby_recommend',
        functionOrder: currentEvent.nearby_recommend_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.seat_info){
      var item = {
        functionName: 'seat_info',
        functionOrder: currentEvent.seat_info_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.outside_link){
      var item = {
        functionName: 'outside_link',
        functionOrder: currentEvent.outside_link_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.interactive_answer){
      var item = {
        functionName: 'interactive_answer',
        functionOrder: currentEvent.interactive_answer_order
      };
      self.functinList.push(item)
    }
    if (currentEvent.lottery){
      var item = {
        functionName: 'lottery',
        functionOrder: currentEvent.lottery_order
      };
      self.functinList.push(item)
    }
    console.info("------------functinList: "+JSON.stringify(self.functinList));
    self.reOrderFunction();
    self.showFunction();
  },

  reOrderFunction: function(){
    var self = Obj;

    var temp = {};
    for (var i = 0; i < self.functinList.length; i++)
    {
      for (var j = 0; j < self.functinList.length-i-1; j++)
      {
        if (self.functinList[j].functionOrder > self.functinList[(j+1)].functionOrder)
        {
          temp = self.functinList[(j+1)];
          self.functinList[(j+1)] = self.functinList[j];
          self.functinList[j] = temp;
        }
      }
    }
  },

  showFunction: function(){
    var self = Obj;
    $.each(self.functinList,function (index,item){
      switch(item.functionName)
      {
      case 'admission_certificate':
        $("#sortable").append(self.show_admission_certificate());
        break;
      case 'session_schedule':
        $("#sortable").append(self.show_session_schedule());
        break;
      case 'hotel_info':
        $("#sortable").append(self.show_hotel_info());
        break;
      case 'seat_info':
        $("#sortable").append(self.show_seat_info());
        break;
      case 'nearby_recommend':
        $("#sortable").append(self.nearby_recommend());
        break;
      case 'outside_link':
        $("#sortable").append(self.outside_link());
        break;
      case 'interactive_answer':
        $("#sortable").append(self.interactive_answer());
        break;
      case 'lottery':
        $("#sortable").append(self.lottery());
        break;
      }

      $('.remove').on('click', function(){
        $(this).parent().remove();
      });
    });
  },

  lottery:function(){
    return "<li data-function-name='lottery' class='ui-state-default'>"+
      "<span class='glyphicon glyphicon-list'></span>现场抽奖"+
      "<button class'remove'>移除</button>"+
    "</li>";
  },

  interactive_answer: function(){
    return "<li data-function-name='interactive_answer' class='ui-state-default'>"+
        "<span class='glyphicon glyphicon-list'></span>互动问答"+
        "<button class='remove'>移除</button>"+
      "</li>";
  },

  outside_link: function(){
    return "<li data-function-name='outside_link' class='ui-state-default'>"+
      "<span class='glyphicon glyphicon-list'></span>站外链接"+
      "<button class='remove'>移除</button>"+
      "</li>";
  },

  nearby_recommend: function(){
    return "<li data-function-name='nearby_recommend' class='ui-state-default'>"+
        "<span class='glyphicon glyphicon-list'></span>周边推荐"+
      "<button class='remove'>移除</button>"+
      "</li>";
  },

  show_seat_info: function(){
    return "<li data-function-name='seat_info' class='ui-state-default'>"+
        "<span class='glyphicon glyphicon-list'></span>座位信息"+
        "<button class='remove'>移除</button>"+
      "</li>";
  },

  show_hotel_info: function(){
    return "<li data-function-name='hotel_info' class='ui-state-default'>"+
        "<span class='glyphicon glyphicon-list'></span>酒店信息"+
        "<button class='remove'>移除</button>"+
      "</li>";
  },

  show_session_schedule: function(){
    return "<li data-function-name='session_schedule' class='ui-state-default'>"+
        "<span class='glyphicon glyphicon-list'></span>会议日程"+
        "<button class='remove'>移除</button>"+
        "</li>";
  },

  show_admission_certificate: function(){
    return "<li data-function-name='admission_certificate' class='ui-state-default'>"+
      "<span class='glyphicon glyphicon-list'></span>入场凭证（个人二维码）"+
      "<button class='remove'>移除</button>"+
    "</li>";
  },

  onGetEventFunctionFailure: function(event){
    var self = Obj;
    alert("network error please try again!");
  },

  getEventFunction: function(){
    var self = Obj;
    var eventId = $("#event-id").data('event-id');
    $.getJSON('/app/events/'+eventId+'.json', 
      {
        name: 'zhangsan'
      },
      self.onGetEventFunctionSuccess).error(self.onGetEventFunctionFailure);
  },

  initialize: function(){
  	var self = Obj;
    self.getEventFunction();
    $('#saveFunctionOrder').on('click', self.onSaveFunctionOrderClicked);
  }
};

$(function() {
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  Obj.initialize();
});
