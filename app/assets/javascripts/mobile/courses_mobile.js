//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


// click handler for show/hide search button (applicable to mobile only)

function moreClick(){
    $('#adv_search').slideToggle(150);
}

function correctHourFormat(time){
    return parseInt(time / 60 % 24, 10 );
}
function correctMinuteFormat(time){
    var minutes = time % 60 ;
    if(minutes < 10){
        minutes = "0"+minutes;
    }
    return minutes;
}

function correctTimeFormat(hour, minute){
    var time = "pm";
    if( hour < 12 ){
        time = "am";
    }
    else if( hour > 12 ){
        hour = hour-12;
    }
    return hour+":"+minute+time;

}

function slideTime(){
    var start_hour = correctHourFormat( $( "#start_time_range" ).val() );
    var start_minute = correctMinuteFormat( $( "#start_time_range" ).val() );
    var end_hour = correctHourFormat( $( "#end_time_range" ).val() );
    var end_minute = correctMinuteFormat( $( "#end_time_range" ).val() );

    $( "#start_hour").val(start_hour);
    $( "#start_minute").val(start_minute);
    $( "#end_hour").val(end_hour);
    $( "#end_minute").val(end_minute);

    //Setting correct display for start time label
    $( "#time_start_label").val( correctTimeFormat(start_hour, start_minute) );

    //Setting correct display for end time label
    $( "#time_end_label").val( correctTimeFormat(end_hour, end_minute) );
}


$(document).ready(function() {

    // toggle radio buttons except for wint,wadv,any
    // TODO: fix this for mobile site
    $('input[type="radio"]').click(function() {
//    $('.search_form').find('input:radio').click(function() {
	var radio_type = "name="+$(this).attr("name");


	if ($(this).attr('name') != "profic") {
	    var name = $(this).attr('name');
	    var value;
	    if (name == "fc") { // FC, HC, CC
		value = $(this).val().substr(0,2);
	    } else { // Modules
		value = $(this).val().substr(0,4);
	    };

	    switch(value) {
	    case "fc":
		$('#hc_radio').attr('pState', false);
		$('#cc_radio').attr('pState', false);
		break;

	    case "hc":
		$('#fc_radio').attr('pState', false);
		$('#cc_radio').attr('pState', false);
		break;

	    case "cc":
		$('#fc_radio').attr('pState', false);
		$('#hc_radio').attr('pState', false);
		break;

	    case "mod1":
		$('#mod2_radio').attr('pState', false);
		$('#full_radio').attr('pState', false);
		$('#spec_radio').attr('pState', false);
		break;

	    case "mod2": 
		$('#mod1_radio').attr('pState', false);
		$('#full_radio').attr('pState', false);
		$('#spec_radio').attr('pState', false);
		break;

	    case "full":
		$('#mod1_radio').attr('pState', false);
		$('#mod2_radio').attr('pState', false);
		$('#spec_radio').attr('pState', false);
		break;

	    case "spec":
		$('#mod1_radio').attr('pState', false);
		$('#mod2_radio').attr('pState', false);
		$('#full_radio').attr('pState', false);
		break;
	    }

	    var radio_id = "#" + value + "_radio";
	    $('#fc_radio').addClass(radio_id);
	    var pState = $(radio_id).attr('pState');
	    if(pState=='true'){
//		$(radio_id).checkboxradio();
		$(radio_id).removeClass('ui-btn-active');
		$(radio_id).removeClass('ui-btn-on')
		$(radio_id).addClass('ui-radio-off');
//		$(radio_id).checkboxradio("refresh");
//		$(radio_id).checkboxradio();
//		$(radio_id).removeAttr('checked').removeAttr('selected').checkboxradio('refresh');
//		$(radio_id).removeAttr('checked').removeAttr('selected');
		var selector = "#"+name+"_"+value;
		$('input[value='+$(selector).val()+']').attr('checked', false).attr('selected', false).checkboxradio('refresh');
		$('#'+name+'_'+value).val(value+value);
	    } else {
		$('#'+name+'_'+value).val(value);
	    };

//	    $(radio_id).attr('pState', $(radio_id).hasClass('ui-btn-active'));
	    if(pState == "true") {
		$(radio_id).attr('pState', false);
	    } else {
		$(radio_id).attr('pState', true);
	    };
	};
    });

    var search_choice = true;

    slideTime();

    $( "#time_slider_div input").on( "change", function() {
      slideTime();
    });

  //Makes sure the user wants to do a full semester search if no fields were filled in
  $('#course_search').click(function(){
      //Searches for input fields in "sf"
      var form = $("input", document.forms["sf"]);

      var searchcrit = false;
      var stringtest = "";
      var valuetest = "";
      $(form).each(function() {
	  var form_id = $(this).attr('id');
	  var type = $(this).attr('type');
	  var thevalue = $(this).val();
// filtering out the ones we don't want to check
	  if (form_id != undefined && form_id != "cart_id" && form_id != "course_search" && form_id != "min_credit_range" && form_id != "max_credit_range" && form_id != "start_time_range" && form_id != "end_time_range" && form_id != "min_level_range" && form_id != "max_level_range" && form_id != "min_size_range" && form_id != "max_size_range" && form_id != "min_enrollment_range" && form_id != "max_enrollment_range" && form_id != "fc_togg" && form_id != "module_togg" && form_id != "key_button_all" && form_id != "key_button_any" && form_id != "time_start_label" && form_id != "time_end_label" ) {
	      // switch statement dealing with different types of form input
	      switch (type) {
	      case "text": 
		  if (thevalue != "" && thevalue!=undefined) {
		      searchcrit = true;
		  };
		  break;

	      case "checkbox":
		  if ($(this).prop('checked')) {
		      searchcrit = true;
		  };
		  break;

	      case "radio":
		  if ($(this).prop('checked')) {
		      searchcrit = true;
		  };
		  break;

	      case "hidden":
		  // switch statement dealing with the different types of hidden input
		  switch (form_id) {
		  case "min_credits":
		      if (thevalue > 0) {
			  searchcrit = true;
		      };
		      break;

		  case "max_credits":
		      if (thevalue < 8) {
			  searchcrit = true;
		      };
		      break;

		  case "start_hour":
		      if (thevalue != "" && thevalue != 7) {
			  searchcrit = true;
		      };
		      break;

		  case "start_minute":
		      if (thevalue != "" && thevalue != "00"){
			  searchcrit = true;
		      };
		      break;

		  case "end_hour":
		      if (thevalue != "" && thevalue != 22) {
			  searchcrit = true;
		      };
		      break;

		  case "end_minute":
		      if (thevalue != "" && thevalue != "00") {
			  searchcrit = true;
		      };
		      break;

		  case "min_course_level":
		      if (thevalue > 0) {
			  searchcrit = true;
		      };
		      break;

		  case "max_course_level":
		      if (thevalue < 999) {
			  searchcrit = true;
		      };

		      break;
		  case "min_course_size":
		      if (thevalue > 0) {
			  searchcrit = true;
		      };
		      break;

		  case "max_course_size":
		      if (thevalue < 999) {
			  searchcrit = true;
		      };
		      break;

		  case "min_course_enrollment":
		      if (thevalue > 0) {
			  searchcrit = true;
		      };
		      break;

		  case "max_course_enrollment":
		      if (thevalue < 999) {
			  searchcrit = true;
		      };
		      break;
		  }
		  break;
	      }
	  };
      });

      // checking the dept
      if ($('#dept_drop').val() != "") {
	  searchcrit = true;
      }

      if (searchcrit) {
	  search_crit = true;
      } else {
	  var response = confirm("This search will return every course offered in the specified semester. It will take a few moments to finish...are you sure you'd like to carry out this search?");
	  if (!response){
              $( ".submit div" ).removeClass( "ui-btn-active" );
	      search_choice = false;
	      return false;
	  } else {
	      search_choice = true;
	  };
      };
  });


  $('#adv_button').click(function(){
    moreClick();
    if ($('#adv_button').hasClass('ui-icon-plus')){
      $('#adv_button').buttonMarkup({icon: 'minus'});
    }
    else{
      $('#adv_button').buttonMarkup({icon: 'plus'});
    }
  });

  // status update on search query
  $('#status_bar').ajaxStart(function() {
    $(this).text("Loading...");
  });

  
  //motd cookie
  $( '#motd_container').on("collapsiblecollapse",function( event, ui ){
    var date = new Date();
    date.setTime(date.getTime()+(20*365*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
    date = new Date();
    document.cookie = "motd="+date.toGMTString()+expires+"; path=/";
  });

});
