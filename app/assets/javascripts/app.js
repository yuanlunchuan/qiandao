$(document).on('ready page:load', function(){

    //自动关闭提示框  
    function Alert(str) {  
        var msgw,msgh,bordercolor;  
        msgw=350;//提示窗口的宽度  
        msgh=80;//提示窗口的高度  
        titleheight=25 //提示窗口标题高度  
        bordercolor="#336699";//提示窗口的边框颜色  
        titlecolor="#99CCFF";//提示窗口的标题颜色  
        var sWidth,sHeight;  
        //获取当前窗口尺寸  
        sWidth = document.body.offsetWidth;  
        sHeight = document.body.offsetHeight;  
        //背景div  
        var bgObj=document.createElement("div");  
        bgObj.setAttribute('id','alertbgDiv');  
        bgObj.style.position="absolute";  
        bgObj.style.top="0";  
        bgObj.style.background="#E8E8E8";  
        bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";  
        bgObj.style.opacity="0.6";  
        bgObj.style.left="0";  
        bgObj.style.width = sWidth + "px";  
        bgObj.style.height = sHeight + "px";  
        bgObj.style.zIndex = "10000";  
        document.body.appendChild(bgObj);  
        //创建提示窗口的div  
        var msgObj = document.createElement("div")  
        msgObj.setAttribute("id","alertmsgDiv");  
        msgObj.setAttribute("align","center");  
        msgObj.style.background="white";  
        msgObj.style.border="1px solid " + bordercolor;  
        msgObj.style.position = "absolute";  
        msgObj.style.left = "50%";  
        msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";  
        //窗口距离左侧和顶端的距离   
        msgObj.style.marginLeft = "-225px";  
        //窗口被卷去的高+（屏幕可用工作区高/2）-150  
        msgObj.style.top = document.body.scrollTop+(window.screen.availHeight/2)-150 +"px";  
        msgObj.style.width = msgw + "px";  
        msgObj.style.height = msgh + "px";  
        msgObj.style.textAlign = "center";  
        msgObj.style.lineHeight ="25px";  
        msgObj.style.zIndex = "10001";  
        document.body.appendChild(msgObj);  
        //提示信息标题  
        var title=document.createElement("h4");  
        title.setAttribute("id","alertmsgTitle");  
        title.setAttribute("align","left");  
        title.style.margin="0";  
        title.style.padding="3px";  
        title.style.background = bordercolor;  
        title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";  
        title.style.opacity="0.75";  
        title.style.border="1px solid " + bordercolor;  
        title.style.height="18px";  
        title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";  
        title.style.color="white";  
        title.innerHTML="提示信息";  
        document.getElementById("alertmsgDiv").appendChild(title);  
        //提示信息  
        var txt = document.createElement("p");  
        txt.setAttribute("id","msgTxt");  
        txt.style.margin="16px 0";  
        txt.innerHTML = str;  
        document.getElementById("alertmsgDiv").appendChild(txt);  
        //设置关闭时间
        window.setTimeout(closewin,2000);   
    }

    function closewin() {  
        document.body.removeChild(document.getElementById("alertbgDiv"));  
        document.getElementById("alertmsgDiv").removeChild(document.getElementById("alertmsgTitle"));  
        document.body.removeChild(document.getElementById("alertmsgDiv"));  
    }

    function findAndCheckin(keyword){
        if (!keyword) {
            return;
        }
        $.getJSON('/app/events/1/site/search_attendee.json',
          {
            keyword: keyword
          },
           function(event){
            var token = event.collection[0].token
            siteCheckIn(token);
            $('#key_word_input_box').val('');
    }).error(function(event){
        searchAttendee();
    });
  }

  function binding_rfid(attendee_id, rfid_num){
    $.post('/app/events/1/site/binding_rfid.json',
      {
        attendee_id: attendee_id,
        rfid_num:rfid_num
      },
    function(event){
        Alert('绑定成功');
    }).error(function(event){
      if(event.responseJSON&&event.responseJSON.message[0]){
        alert("绑定失败"+event.responseJSON.message[0]);
    }
    });
  }

    $('.save-attendee-rfid').on('click', function(event){
        var rfid = $(('#'+$(this).data('attendee-id'))).val();
        var attendeeId = $(this).data('attendee-id');
        binding_rfid(attendeeId, rfid);
    });

    $('#admin_root').on('click', function(event){
      if($('#admin_root').prop('checked')){
        $('#admin_restaurant_permission').prop("checked", true);
        $('#admin_session_manage_permission').prop("checked", true);
        $('#admin_session_notifacation_permission').prop("checked", true);
        $('#admin_attendee_manage_permission').prop("checked", true);
        $('#admin_checkin_manage_permission').prop("checked", true);
        $('#admin_interaction_manage_permission').prop("checked", true);
        $('#admin_seller_manage_permission').prop("checked", true);
      }else{
        $('#admin_restaurant_permission').prop("checked", false);
        $('#admin_session_manage_permission').prop("checked", false);
        $('#admin_session_notifacation_permission').prop("checked", false);
        $('#admin_attendee_manage_permission').prop("checked", false);
        $('#admin_checkin_manage_permission').prop("checked", false);
        $('#admin_interaction_manage_permission').prop("checked", false);
        $('#admin_seller_manage_permission').prop("checked", false);
      }
    });

    $('input[autocomplete=off]').on('focus', function(){
        $(this).attr('readonly', false);
    });

    $('.input-daterange').datepicker({
        format: 'yyyy-mm-dd',
        //startDate: '+1d',
        forceParse: false,
        weekStart: 1,
        todayHighlight: true,
        autoclose: true
    });

    $('.input-daterange-group').datepicker({
        format: 'yyyy-mm-dd',
        //startDate: '+1d',
        forceParse: false,
        weekStart: 1,
        todayHighlight: true,
        autoclose: true,
        inputs: $('.actual_range').toArray()

    });

    $('.clockpicker').clockpicker({
        autoclose: true
    });

    if($('.timer-time').size()){
        setInterval(function(){
            var x = new Date();
            var date = x.getFullYear() + ' / ' + (x.getMonth() + 1) + " / " + x.getDate();
            var hours = x.getHours() < 10 ? "0" + x.getHours() : x.getHours();
            var minutes = x.getMinutes() < 10 ? "0" + x.getMinutes() : x.getMinutes();
            var seconds = x.getSeconds() < 10 ? "0" + x.getSeconds() : x.getSeconds();
            var time = hours + ":" + minutes + ":" + seconds;
            $('.timer-time').html(time);
            $('.timer-date').html(date);
        }, 1000)
    }

    $('.site-keyword-input').blur(function(){
        $('.scanner-input').focus();
    });

    $('.scanner-input').blur(function(){
        $('#scanner-indicator').removeClass('text-success');
        $('#scanner-indicator').addClass('text-danger');
        $(this).val('');
    });

    $('.scanner-input').focus(function(){
        $('#scanner-indicator').removeClass('text-danger');
        $('#scanner-indicator').addClass('text-success');
    })

    $('.scanner-input').keydown(function(e){
        if(e.keyCode != 13) return;
        var code = $(this).val();
        findAndCheckin(code);
        $(this).val('');
    });

    $('.modal').keydown(function(e){
        if(e.keyCode == 13) $(this).modal('hide');
    });

    $('.site-keyword-input').keydown(function(e){
        if(e.keyCode != 13){
            return;
        }
        findAndCheckin($('#key_word_input_box').val());
    });
    
    var should_execute_find=false;
    $('.site-search-btn').click(function(){
        findAndCheckin($('#key_word_input_box').val());
        return false;
    });

    $('#refresh').on('click', function(event){
        window.location.reload();
    });

    $('#key_word_input_box').on('change', function(){
      //console.info('----------107');
      //findAndCheckin();
    });

    $('.site-keyword-input').click(function(){
        return false;
    });

    $( ".modal" ).on( "click", ".binding_rfid", function() {
      $('.modal').modal('hide');

      var rfid=prompt("请刷卡","");
      var attendee_id = $(this).data('attendee-id');
      if (rfid)
      {
        binding_rfid(attendee_id, rfid);
      }
    });

    $( ".modal" ).on( "click", ".site-check-in-btn", function() {
        $('.modal').modal('hide');
        var token = $(this).data('token');
        siteCheckIn(token);
    });

    $('#side-list').on('click', '.bind-rfid', function(){
        var attendee_id = $(this).data('attendee-id');
        var rfid=prompt("请刷卡绑定卡号","");
        if (rfid)
        {
          binding_rfid(attendee_id, rfid);
        }
    });

    $('#side-list').on('click', '.site-close-checkin-status', function(){
        hideCheckInStatus();
    });

    $('#side-list').on('click', '.site-uncheck-in-btn', function(){
        var token = $(this).data('token');
        siteUncheckIn(token);
    });

    $('.modal').on('click', '.site-uncheck-in-btn', function(){
        var token = $(this).data('token');
        siteUncheckIn(token);
    });

    $( ".modal" ).on( "click", ".site-print-pdf-btn", function() {
        $('.modal').modal('hide');
        var pdf = $(this).data('pdf');
        printPDF(pdf);
    });

    $( "#side-list" ).on( "click", ".site-print-pdf-btn", function() {
        var pdf = $(this).data('pdf');
        printPDF(pdf);
    });

    $('.modal').on('hide.bs.modal', function () {
        setTimeout(function(){
            $('.scanner-input').val('');
            $('.scanner-input').focus();

        }, 500);
    });

    $('td').on('click', '.print-pdf-btn', function(){
        var pdf = $(this).data('pdf');
        printPDF(pdf);
    });

    function siteUncheckIn(token){
        token = $.trim(token);
        var url = $('.scanner-input').data('url').replace('check_in', 'uncheck_in');
        url = url + '?token='+token + '&ajax=1';
        if(!window.confirm('是否确认取消签到？')) return;
        $('.modal').modal('hide');
        $.ajax(url, {
            type: 'POST',
            success: function(){
                hideCheckInStatus();
                reloadAttendees();
            }
        })
    }

    function siteCheckIn(token){
        token = $.trim(token);
        var url = $('.scanner-input').data('url');
        url = url + '?token='+token + '&ajax=1';

        hideCheckInStatus();

        $.ajax(url, {
            type: 'POST',
            success: function(data){
                if(data.code < 0 ) { //找不到用户。-1: 找不到用户, -2: 已签到
                    siteAlert(data.error, data.message, data.type)
                }else if(data.code == 0){
                    var animation = 'animated bounceIn';
                    showCheckInStatus();
                    $('#checkin-status').html(data.html);
                    $('#checkin-status').addClass(animation).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
                        $(this).removeClass(animation);
                    });
                    playSound();
                    reloadAttendees();
                    // if (!data.attendee.printed) {
                    //   if(confirm('是否打印胸卡?')){
                    //     var pdfUrl = "/app/events/"+data.attendee.event_id+"/attendees/"+data.attendee.id+"/badge.pdf";
                    //     if (!data.attendee.rfid_num) {
                    //         printPDF(pdfUrl, data.attendee.id, true);
                    //     }else{
                    //         printPDF(pdfUrl, false);
                    //     }
                    //   }
                    // }
                }
            }
        });
    };

    function siteAlert(title, message, type){
        swal({
            title: title,
            type:  type,
            text: message
        });
    }

    function hideCheckInStatus(){
        $('#checkin-status').addClass('hidden');
    }

    function showCheckInStatus(){
        $('#checkin-status').removeClass('hidden');
    }

    hideCheckInStatus();

    function playSound(){
        var audio = new Audio('/sounds/piano.mp3')
        audio.play();
    }

    function reloadAttendees(){
        var url = $('.scanner-input').data('attendees-url');
        $('#attendees-list').load(url, function(){});
    }

    reloadAttendees();

    function printPDF(pdf, attendee_id, is_binding_rfid){
        pdf = pdf + '?print=true';
        var w = window.open(pdf);
        w.print();
        setTimeout(function(){
           if (is_binding_rfid) {
              var rfid=prompt("请刷卡绑定卡号","");
              if (rfid)
              {
                binding_rfid(attendee_id, rfid);
              }
           }
        }, 11000);

        setTimeout(function(){
           w.close();
           hideCheckInStatus();
           reloadAttendees();
        }, 10000);
    }

    function searchAttendee(){
        var $input = $('.site-keyword-input');
        var name = $input.val();
        if (name == '') return;
        $input.val('');
        var url = $input.data('url');
        url = url + '?keyword=' + name;
        $('#key_word_input_box').val('');
        $('#site-modal-content').load(url, function(event){
            $('#site-modal').modal();
        });
    }


    $('.scanner-input').focus();

    if($('.scanner-input').size()){
        $(document).click(function(){
            $('.scanner-input').focus();
        })
    }

    $('input[name=has_photo]').change(function(){
        var url = '?has_photo=' + $(this).val();
        Turbolinks.visit(url);
    });

    $('input[name=has_avatar]').change(function(){
        var url = '?has_avatar=' + $(this).val();
        Turbolinks.visit(url);
    });

    //选择标签
    $('select[name=category_id]').change(function(){
        var url = '?category_id=' + $(this).val();
        Turbolinks.visit(url);
    })

    $('input[name=sent_sms]').change(function(){
        var url = '?sent_sms=' + $(this).val();
        Turbolinks.visit(url);
    });

    $('input[name=printed]').change(function(){
        var url = '?printed=' + $(this).val();
        Turbolinks.visit(url);
    });

    $('input[name=checked_in]').change(function(){
        var url = '?checked_in=' + $(this).val();
        Turbolinks.visit(url);
    });

    $('#select-session-checkin').change(function(){
        var url = $(this).val();
        Turbolinks.visit(url);
    });

    $('.re-upload-photo-btn').click(function(){
        $('.photo-preview').addClass('hidden');
        $('.upload-photo-input').removeClass('hidden');
    });

    $('.delete-photo-btn').click(function(){
        var $input = $('input[name=_delete_photo]')
        if($input.val() != '1'){ //第一次点击
            $(this).html('<i class="fa fa-check"> 删除照片');
            $input.val('1');
            $(this).removeClass('btn-outline btn-white');
            $(this).addClass('btn-danger');
        }else{
            $(this).html('删除照片');
            $input.val('');
            $(this).addClass('btn-outline btn-white');
            $(this).removeClass('btn-danger');
        }
    });

    $('.upload-photo-btn').dropzone({
        url: '#',
        maxFiles: 1,
        maxFilesize: 3,
        previewsContainer: '.dropzone-photo-preview',
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        },
        processing: function(){
            this.options.url = $(this.element).data('url');
        },
        sending: function(){
            $('#upload-photo-status').removeClass('hidden');
        },
        error: function(a, error){
            alert(error);
            $('#upload-photo-status').addClass('hidden');
        },
        success: function(a, b){
            Turbolinks.visit(location.href);
            $('#upload-photo-status').addClass('hidden');
        },
        complete: function(){
            this.removeAllFiles(true);
            $('#upload-photo-status').addClass('hidden');
        }
    });

});