// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {
  var $mailer_dialog = $('#cart_mailer_dialog').dialog({
    autoOpen: false,
      title: 'mail_it',
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
});