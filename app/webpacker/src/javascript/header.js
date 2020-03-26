//This file should have all javascript functions that don't require ruby and
//are associated with the header of the app.


$(document).ready(function(){

  //$('#menu_button').button();


  // Shows/Hides links in header (mobile layout)
  $("#menu_button").click(function(){
    //$('#menu_list').slideToggle(150);
    if ($('#menu_list').collapsible( "option", "collapsed" )) {
   //   $('#menu_button').buttonMarkup({icon: 'carrat-u'});
      $('#menu_list').collapsible("expand");
    }
    else{
   //   $('#menu_button').buttonMarkup({icon: 'carrat-d'});
      $('#menu_list').collapsible("collapse");
    }
   // $('#menu_button').button('refresh');
  });

  //Dynamically sizes the logo on mobile pages
  $('#logo').load(function(){
    var height = $('#logo').height();
    var width = $('#logo').width();
    $('#menu_list').css("top", height+"px"); 
  });



});
