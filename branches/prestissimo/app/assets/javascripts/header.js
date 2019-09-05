//This file should have all javascript functions that don't require ruby and
//are associated with the header of the app.

$(document).ready(function(){

  // Shows/Hides links in header (mobile layout)
  $("#menu_button").click(function(){
    $('#menu_list').slideToggle(150);
    if ($('#menu_button').jqmData('icon') == 'arrow-d'){
      $('#menu_button').buttonMarkup({icon: 'arrow-u'});
    }
    else{
      $('#menu_button').buttonMarkup({icon: 'arrow-d'});
    }
  });

  //Dynamically sizes the logo on mobile pages
  $('#logo').load(function(){
    var height = $('#logo').height();
    var width = $('#logo').width();
    $('#menu_list').css("top", height+"px"); 
  });



});
