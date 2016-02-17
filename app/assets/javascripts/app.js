$(document).on('ready page:load', function(){
    function findAndCheckin(){
        var keyword = $('#key_word_input_box').val();
        if (!keyword) {
            return;
        }
        if ($('#key_word_input_box').val()) {
            $.getJSON('/app/events/1/site/rfid_search.json',
              {
                keyword: $('#key_word_input_box').val()
              },
               function(event){
                var token = event.collection[0].token
                siteCheckIn(token);
                $('#key_word_input_box').val('');
        }).error(function(event){
            searchAttendee();
        });
    }
  }

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
        $(this).val('');

        if(/(.+)\/(.+)/.test(code)){
            var token = code.split('/')[0];
            siteCheckIn(token);
        }
    });

    $('.modal').keydown(function(e){
        if(e.keyCode == 13) $(this).modal('hide');
    });

    $('.site-keyword-input').keydown(function(e){
        if(e.keyCode != 13){
            return;
        }
        findAndCheckin();
    });
    
    var should_execute_find=false;
    $('.site-search-btn').click(function(){
        findAndCheckin();
        return false;
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
        $.post('/app/events/1/site/binding_rfid.json',
          {
            session_id: 1,
            attendee_id: attendee_id,
            rfid_num:rfid
          },
        function(event){
        }).error(function(event){
          if(event.responseJSON&&event.responseJSON.message[0]){
            alert("绑定失败"+event.responseJSON.message[0]);
        }
        });
     }
    });

    $( ".modal" ).on( "click", ".site-check-in-btn", function() {
        $('.modal').modal('hide');
        var token = $(this).data('token');
        siteCheckIn(token);
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

    function printPDF(pdf){
        pdf = pdf + '?print=true';
        var w = window.open(pdf) ;
        w.print();
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