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

    $('#cloudsignin-logo').addClass('animated flipInX');
    $('#cloudsignin-enter-btn').addClass('animated fadeInRight');
    $('#cloudsignin-invitation').addClass('animated fadeInRight');
    $('#cloudsignin-event-title').addClass('animated fadeInLeft');
    $('#background-container').addClass('animated fadeInLeft');

    $('#upload_photo').dropzone({
        url: 'upload',
        maxFiles: 1,
        maxFilesize: 3,
        sending: function(){
            $('.loading-animation').removeClass('hidden');
        },
        success: function(a, b){
            $('.cloudsignin-done-btn').removeClass('hidden');
            $('#upload_photo').attr('src', b.url);
            $('.cloudsignin-done-btn').addClass('animated fadeIn');
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
