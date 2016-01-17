//= require jquery
//= require jquery_ujs
//= require dropzone/dropzone.js
//= require_self


$(document).on('ready page:load', function() {
    if(typeof(scrollDisabled) != 'undefined'){
        document.ontouchmove = function(event){
            event.preventDefault();
        }
    }

    $('#yonex-logo').addClass('animated flipInX');
    $('#yonex-enter-btn').addClass('animated fadeInRight');
    $('#yonex-invitation').addClass('animated fadeInRight');
    $('#yonex-event-title').addClass('animated fadeInLeft');
    $('#background-container').addClass('animated fadeInLeft');

    $('#upload_photo').dropzone({
        url: 'upload',
        maxFiles: 1,
        maxFilesize: 3,
        sending: function(){
            $('.loading-animation').removeClass('hidden');
        },
        success: function(a, b){
            $('.yonex-done-btn').removeClass('hidden');
            $('#upload_photo').attr('src', b.url);
            $('.yonex-done-btn').addClass('animated fadeIn');
        },
        error: function(a, error){
            alert(error);
        },
        complete: function(file){
            this.removeFile(file);
            $('.loading-animation').addClass('hidden');
        }
    });
});
