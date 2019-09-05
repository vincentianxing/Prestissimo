// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {
    function createCookie(name,value,days) {
        if (days) {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            var expires = "; expires="+date.toGMTString();
        }
        else var expires = "";
        document.cookie = name+"="+value+expires+"; path=/";
    }

    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }

    function eraseCookie(name) {
        createCookie(name,"",-1);
    }
    $( "#cart_container" )
        .css({
            top: readCookie("cartY")*1,
            left: readCookie("cartX")*1 });

    var $mailer_dialog = $('#cart_mailer_dialog').dialog({
        autoOpen: false,
        title: 'Email Courses',
        resizable: false,
        modal: true,
        draggable: true,
        closeText: "X"
    });
  $('#mail_cart_link').click(function(){
    $mailer_dialog.dialog('open');
  });
  // show the info of a clicked course
  var box_id = "";

  $('td.car_inf').click(function() {

    var clicked_id = $(this).parent().attr("id");
    if (!(clicked_id == $(box_id+"_entry").attr("id"))){
      $(this).parent().addClass('selected');
      $(box_id).hide();
      $(box_id+"_entry").removeClass('selected');
    }
    else{

      if ($(this).parent().hasClass('selected')){
	$(this).parent().removeClass('selected');
      }
      else{
	$(this).parent().addClass('selected');
      }

    }
    box_id = "#" + clicked_id.split("_entry")[0];
    $(box_id).toggle("fast");
  });


  $('#minimize_cart').hover(function(){
      $(this).css("background-color", "#C72F1B");
  },
  function(){
      $(this).css("background-color", "inherit");
  });

  $('#minimize_cart').click(function(){
      $("#cart_container").hide();
      $("#minimized_cart").show();

  });

    $('#minimized_cart').click(function(){
        $("#cart_container").show();
        $("#minimized_cart").hide();

    });
//    $('#cart_container').animate({left: '220px'});
});
