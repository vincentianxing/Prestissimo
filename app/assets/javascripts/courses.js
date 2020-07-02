//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

// This function is only used by mobile site
function moreClick() {
}

// checks to see if the load_cart cookie is set
// if so, clicks the load cart button to actually load the cart
// and deletes the load_cart cookie
$(document).ready(function() {
  // only do stuff if we are on the homepage
  if((window.location.origin == window.location.href) || (window.location.origin + "/" == window.location.href)){
    var nameEQ = "load_cart=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1,c.length);
      if (c.indexOf(nameEQ) == 0) { 
        var lc = document.getElementById('load_cart');
        lc.click();
      }
    }
  }
  // remove the cookie!
  // happens regardless of what page we are on.
  var date = new Date();
  date.setTime(date.getTime()-(24*60*60*1000));
  var expires = "; expires="+date.toGMTString();
  document.cookie = "load_cart="+expires+"; path=/";
});

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

function slideTime(event, ui){
    var start_hour = correctHourFormat( ui.values[ 0 ]);
    var start_minute = correctMinuteFormat( ui.values[ 0 ]);
    var end_hour = correctHourFormat( ui.values[ 1 ]);
    var end_minute = correctMinuteFormat( ui.values[ 1 ]);

    $( "#start_hour").val(start_hour);
    $( "#start_minute").val(start_minute);
    $( "#end_hour").val(end_hour);
    $( "#end_minute").val(end_minute);

    //Setting correct display for start time label
    $( "#start_time_range").val( correctTimeFormat(start_hour, start_minute) );

    //Setting correct display for end time label
    $( "#end_time_range").val( "-  " + correctTimeFormat(end_hour, end_minute) );
}

function prettyCredits(credits){
    if(credits >= 8 ){
        return "8+"
    }
    if (credits.toString().length == 1){
        return credits + ".0";
    }
    return credits

}

function slideLevel(event, ui){
    var min_level = ui.values[ 0 ];
    var max_level = ui.values[ 1 ];
    $("#max_course_level").val( correctMaxLevel(max_level) );
    $("#min_course_level").val( min_level );
    $("#min_level_range").val( prettyLevel(min_level) );
    $("#max_level_range").val( "-  " + prettyLevel(correctMaxLevel(max_level)) );
}

function prettyLevel(level){
    if(level == 0){
        return "000";
    }
    else if(level > 500){
        return "500+";
    }
    else if(level == 99){
        return "099";
    }
    else{
        return level;
    }
}

function correctMaxLevel(level){
    if(level == 0){
        return 0;
    }
    else if(level > 500) {
        return 999;
    }
    else{
        return level-1;
    }
}

function slideSize(event, ui){
    var min_size = ui.values[ 0 ];
    var max_size = ui.values[ 1 ];
    $("#max_course_size").val( correctMaxSize(max_size) );
    $("#min_course_size").val( correctMinSize(min_size) );
    $("#min_size_range").val( prettySize(correctMinSize(min_size)) );
    $("#max_size_range").val( "-  " + prettySize(correctMaxSize(max_size)) );
}

function prettySize(size){
    if(size == 0){
        return "0";
    }
    else if(size > 200){
        return "200+";
    }
    else{
        return size;
    }
}

function correctMinSize(size){
    if(size == 0){
        return 0;
    }
    else if(size == 5) {
        return 1;
    }
    else if(size == 60) {
        return 100;
    }
    else if(size > 60) {
        return 200;
    }
    else{
        return size - 5;
    }
}

function correctMaxSize(size){
    if(size == 0){
        return 0;
    }
    else if(size == 5) {
        return 1;
    }
    else if(size == 60) {
        return 100;
    }
    else if(size > 60) {
        return 999;
    }
    else{
        return size - 5;
    }
}

function slideEnrollment(event, ui){
    var min_enrollment = ui.values[ 0 ];
    var max_enrollment = ui.values[ 1 ];
    $("#max_course_enrollment").val( correctMaxSize(max_enrollment) );
    $("#min_course_enrollment").val( correctMinSize(min_enrollment) );
    $("#min_enrollment_range").val( prettySize(correctMinSize(min_enrollment)) );
    $("#max_enrollment_range").val( "-  " + prettySize(correctMaxSize(max_enrollment)) );
}

$(document).ready(function() {

    // toggle radio buttons except for wint,wadv,any
    $('input[type="radio"]').click(function() {
	if ($(this).attr('name') != "profic") {
	    var name = $(this).attr('name');
	    var value;
	    if (name == "fc") { // FC, HC, CC
		value = $(this).val().substr(0,2);
	    } else if (name == "module") { // Modules
		value = $(this).val().substr(0,4);
            } else { //Keyword toggle
                value = $(this).val().substring(0,7);
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

            case "any_key":
                $('#all_key_radio').attr('pState', false);
                break;

            case "all_key":
                $('#any_key_radio').attr('pState', false);
                break;

            }

	    var radio_id = "#" + value + "_radio";

	    var pState = $(radio_id).attr('pState');
	    if(pState=='true'){
		$(radio_id).removeClass('ui-state-active');
		$(radio_id).attr('aria-pressed', false);
		$('#'+name+'_togg').prop('checked', true);
		$('#'+name+'_'+value).val(value+value);
	    } else {
		$('#'+name+'_'+value).val(value);
	    };

	    $(radio_id).attr('pState', $(radio_id).attr('aria-pressed'));
	};
    });

    // toggles wint,wadv,any when wr clicked
    $('#wr_checkbox').click(function() {
	$('#wr_profic_div').toggle();
	$('#profic_any').prop("checked", true);
	$('#profic_any').button("refresh");
	if (!($('#profic_any').hasClass('ui-state-active'))) {
	    $('#profic_any').removeClass('ui-state-active');
	    $('#profic_any').attr('aria-pressed', false);
	};
    });

    var search_choice = true;

    $( "#time_sliderdiv").slider({
        range: true,
        min: 420,
        max: 1320,
        values: [480, 1260],
        step: 5,
        slide: slideTime
    });

    $( "#start_time_range").val( correctTimeFormat( correctHourFormat($("#time_sliderdiv").slider( "values", 0)), correctMinuteFormat( $("#time_sliderdiv").slider( "values", 0)) ));
    $( "#end_time_range").val( "-  "+correctTimeFormat( correctHourFormat($("#time_sliderdiv").slider( "values", 1)), correctMinuteFormat( $("#time_sliderdiv").slider( "values", 1)) ));

    $( "#credit_sliderdiv").slider({
        range: true,
        min: 0,
        max: 8,
        values: [0, 8],
        step: 0.5,
        slide: function( event, ui){
            $( "#min_credits").val( ui.values[ 0 ] );
            if( ui.values[ 1 ] >= 8){
                $( "#max_credits").val( 99 ); //since there are some courses that are randomly worth a ton of crediits
            }
            else{
                $( "#max_credits").val( ui.values[ 1 ] );
            }
            $( "#min_credit_range").val( prettyCredits(ui.values[ 0 ] ) );
            $( "#max_credit_range").val( "-  " + prettyCredits(ui.values[ 1 ]) );
        }
    });

    $( "#min_credit_range").val( prettyCredits($("#credit_sliderdiv").slider( "values", 0)) );
    $( "#max_credit_range").val("-  " + prettyCredits($("#credit_sliderdiv").slider( "values", 1)) );
    $( "#min_credits").val( 0 );
    $( "#max_credits").val( 99 );

    //$( ".day_buttonset").buttonset();
    $('#days_div').buttonset();
    $('#days_div1').button( { icons: {primary:'ui-icon-gear', secondary:'null'}});
    $('#proficiencies_div').buttonset();
    $('#attributes_div').buttonset();
    $('#remote_div').buttonset();
    $('#modules_div').buttonset();
    $('#full_course_div').buttonset();
    $('#wr_profic_div').buttonset();
    $('#con_attributes_div').buttonset();
    $('#keyword_buttons_div').buttonset();

    $('#which_desc_div').buttonset();
    $('#course_desc_action_div').buttonset();
    
    //$('#days_div').removeClass(".ui-button .ui-button-text")

    $( "#level_slider").slider({
        range: true,
        min: 0,
        max: 600,
        values: [0, 600],
        step: 100,
        slide: slideLevel
    });

    $("#min_level_range").val(prettyLevel($("#level_slider").slider("values", 0)));
    $("#max_level_range").val("-  " + prettyLevel(correctMaxLevel($("#level_slider").slider("values", 1))));
    $("#min_course_level").val("0");
    $("#max_course_level").val(correctMaxLevel($("#level_slider").slider("values", 1)));

    $( "#size_slider").slider({
        range: true,
        min: 0,
        max: 65,
        values: [0, 65],
        step: 5,
        slide: slideSize
    });

    $("#min_size_range").val(prettySize($("#size_slider").slider("values", 0)));
    $("#max_size_range").val("-  " + prettySize(correctMaxSize($("#size_slider").slider("values", 1))));
    $("#min_course_size").val("0");
    $("#max_course_size").val(correctMaxSize($("#size_slider").slider("values", 1)));

    $( "#enrollment_slider").slider({
        range: true,
        min: 0,
        max: 65,
        values: [0, 65],
        step: 5,
        slide: slideEnrollment
    });

    $("#min_enrollment_range").val(prettySize($("#enrollment_slider").slider("values", 0)));
    $("#max_enrollment_range").val("-  " + prettySize(correctMaxSize($("#enrollment_slider").slider("values", 1))));
    $("#min_course_enrollment").val("0");
    $("#max_course_enrollment").val(correctMaxSize($("#enrollment_slider").slider("values", 1)));

  //Actually resets the search criteria on mobile
  $('.mobile_reset').click(function(){
    $('.search_form').find('input:text, select, textarea').val(''); 
    $('.search_form').find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected').checkboxradio('refresh');
      $('.search_form').find('select').selectmenu("refresh");
    $('#min_credits').slider('refresh');
    $('#max_credits').slider('refresh');
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
	  if (form_id != undefined && form_id != "cart_id" && form_id != "course_search" && form_id != "min_credit_range" && form_id != "max_credit_range" && form_id != "start_time_range" && form_id != "end_time_range" && form_id != "min_level_range" && form_id != "max_level_range" && form_id != "min_size_range" && form_id != "max_size_range" && form_id != "min_enrollment_range" && form_id != "max_enrollment_range" && form_id != "fc_togg" && form_id != "module_togg" && form_id != "key_button_all" && form_id != "key_button_any") {
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
		      if (thevalue != "" && thevalue != 8) {
			  searchcrit = true;
		      };
		      break;

		  case "start_minute":
		      if (thevalue != "" && thevalue != "00"){
			  searchcrit = true;
		      };
		      break;

		  case "end_hour":
		      if (thevalue != "" && thevalue != 21) {
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
      if ($('#dept_text').val() != "") {
	  searchcrit = true;
      }

      if (searchcrit) {
	  search_crit = true;
      } else {
	  var response = confirm("This search will return every course offered in the specified semester. It will take a few moments to finish...are you sure you'd like to carry out this search?");
//	  var response = confirm(stringtest + "\n" + valuetest);
	  if (!response){
	      search_choice = false;
	      return false;
	  } else {
	      search_choice = true;
	  };
      };
  });

  $('#adv_link').click(moreClick);

  $('#adv_button').click(function(){
    moreClick();
    if ($('#adv_button').jqmData('icon') == 'plus'){
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

  //This is needed to display the loading message during searches on the mobile layout
  $('input').click(function(){
    if (($(this).attr("type") == "submit") && search_choice){
      $('#status_bar').text("Loading...");
    }
  });

  /*///////OLD CODE!!!!

  //this is the text that will appear in the hover boxes
  //var form_helpers_hover = new Array();

  ////////////////////////////
  ///form_helpers_hover//////
  ////////////////////////////
  
  //form_helpers_hover['cname'] = 'Search for course name by keyword.';

  //form_helpers_hover['professor'] = 'Search by professor name. Example: "Marvin", "Krislov", or "Marvin Krislov".'; 

  //form_helpers_hover['dept'] = 'Search by department. Selecting multiple departments will display all courses from each selected department.';

  //form_helpers_hover['semester'] = 'Search by semester; some past semesters are available for viewing.' + '\nPrestissimo updates to the new catalog when it becomes available midway through the preceding semester.';

  //form_helpers_hover['proficiencies'] = 'Search by proficiency. Selecting more than one box will return classes that offer all of the selected proficiencies.'

  //form_helpers_hover['days'] = 'Search by day. Selecting more than one day will show only courses that meet on all of the selected days.';

  //form_helpers_hover['modules'] = 'Search by course length.\n' + ' First module runs from the start of the semester until the week of break.\n'
  //  + 'Second module runs from the week of break until the end of the semester.\n'
  //  + 'Special indicates a class with various meeting times.\n'
  //  + 'All other classes are full semester classes.';

  //form_helpers_hover['attributes'] = 'Search by division. If more than one division is selected, then only courses that are in all selected divisions will be shown.';

  //form_helpers_hover['credits'] = 'Search by credit amount, inclusive.';

  //form_helpers_hover['crn'] = 'Search by partial or whole CRN.';

  //form_helpers_hover['time'] = 'Search by start and end time, inclusive.';

  //form_helpers_hover['level'] = 'Search by course level.';

  //Commented out r1113 - not sure what field it is describing.
  //form_helpers_hover['date'] = 'Any courses modified since the given date (e.g. a course\'s location, time, professor) are found.'
  //  + '\nSelecting only the day finds the courses changed since the given day in the current month and year.'
  //  + '\nSelecting only the month finds the courses changed since the beginning of the given month.'
  //  + '\nSelecting only the year finds the couses changed since January 1 of the given year.'
  //  + '\nSelecting a day and month without a year finds the courses changed since the month and day in the current year.';

  //form_helpers_hover['full_course'] = 'Search for full credit, half credit, or co-curricular courses.';

  //form_helpers_hover['con_attributes'] = 'Search by conservatory course attribute. CNDP denotes conservatory courses that count as Arts & Humanities courses.' + '\nDDHU denotes conservatory courses that count as Arts & Humanities courses for the Double Degree program.';

  //form_helpers_hover['keyword'] = 'Keyword search of course descriptions, titles, departments, crosslistings, and prerequisites.';

    $('.search_label').hover(function() {
      var helper_id = $(this).parent().attr('id').split('_')[0];
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

// A lot of repetitive code down here. Should change that somehow.    

    $("#time_sliderdiv_wrapper").hover(function() {
      var helper_id = 'time';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });
    
    $("#attributes_div").hover(function() {
      var helper_id = 'attributes';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#proficiencies_div").hover(function() {
      var helper_id = 'proficiencies';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#modules_div").hover(function() {
      var helper_id = 'modules';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#con_attributes_div").hover(function() {
      var helper_id = 'con_attributes';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#days_div").hover(function() {
      var helper_id = 'days';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#full_course_div").hover(function() {
      var helper_id = 'full_course';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $("#credit_slider_wrapper").hover(function() {
      var helper_id = 'credits';
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });


    $('#date_div select').hover(function() {
      var helper_id = $(this).parent().attr('id').split('_')[0];
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $('.search_tag:checkbox').hover(function() {
      var helper_id = $(this).parent().attr('id').split('_')[0];
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });
    */

///overwriting reset button functionality
    $( "#course_reset").click( function () {
        $("#cname_field").val("");
        $("#crn_field").val("");
        $("#dept_drop").val("");
        $("#keyword_field").val("");
	$("#dept_text").empty();
        $("#dept_list").empty();
	$("#dept_list").text("No departments selected");
        $("#time_sliderdiv").slider('values', 0, 480);
        $("#time_sliderdiv").slider('values', 1, 1260);
        $( "#end_hour").val( "");
        $( "#end_minute").val( "");
        $( "#start_hour").val( "");
        $( "#start_minute").val( "");
        $( "#start_time_range").val( correctTimeFormat( correctHourFormat($("#time_sliderdiv").slider( "values", 0)), correctMinuteFormat( $("#time_sliderdiv").slider( "values", 0)) ));
        $( "#end_time_range").val( "-  "+correctTimeFormat( correctHourFormat($("#time_sliderdiv").slider( "values", 1)), correctMinuteFormat( $("#time_sliderdiv").slider( "values", 1)) ));

        $("#level_slider").slider('values', 0, 0);
        $("#level_slider").slider('values', 1, 600);
        var min_level = $("#level_slider").slider("values", 0);
        var max_level = $("#level_slider").slider("values", 1);
        $("#min_course_level").val( min_level );
        $("#max_course_level").val( correctMaxLevel(max_level) );
        $("#min_level_range").val( prettyLevel(min_level) );
        $("#max_level_range").val( "-  " + prettyLevel(correctMaxLevel(max_level)) );

        $("#size_slider").slider('values', 0, 0);
        $("#size_slider").slider('values', 1, 65);
        var min_size = $("#size_slider").slider("values", 0);
        var max_size = $("#size_slider").slider("values", 1);
        $("#min_course_size").val( correctMinSize(min_size) );
        $("#max_course_size").val( correctMaxSize(max_size) );
        $("#min_size_range").val( prettySize(correctMinSize(min_size)) );
        $("#max_size_range").val( "-  " + prettySize(correctMaxSize(max_size)) );

        $("#enrollment_slider").slider('values', 0, 0);
        $("#enrollment_slider").slider('values', 1, 65);
        var min_enrollment = $("#enrollment_slider").slider("values", 0);
        var max_enrollment = $("#enrollment_slider").slider("values", 1);
        $("#min_course_enrollment").val( correctMinSize(min_enrollment) );
        $("#max_course_enrollment").val( correctMaxSize(max_enrollment) );
        $("#min_enrollment_range").val( prettySize(correctMinSize(min_enrollment)) );
        $("#max_enrollment_range").val( "-  " + prettySize(correctMaxSize(max_enrollment)) );

        var min_credits = 0;
        var max_credits = 8;
        $( "#credit_sliderdiv").slider("values", 0, min_credits);
        $( "#credit_sliderdiv").slider("values", 1, max_credits);
        $( "#min_credit_range").val( prettyCredits( min_credits ) );
        $( "#max_credit_range").val( "-  "+prettyCredits( max_credits ) );
        $( "#max_credits").val(max_credits);
        $( "#min_credits").val(min_credits);

        $("#professor_field").val("");
        var semester_drop = $("#semester_drop option");
        var cur_semester = semester_drop[0].text;
        $("#semester_drop").val(cur_semester);
        
        $('#key_button_all').attr('checked', 'checked');
        $('#key_button_all').button("refresh");
        $('#key_button_any').removeAttr('checked');
        $('#key_button_any').button("refresh");
        $('#all_key_radio').addClass("ui-state-active");
        $('#ns').removeAttr('checked');
        $('#ns').button("refresh");
        $('#ss').removeAttr('checked');
        $('#ss').button("refresh");
        $('#hu').removeAttr('checked');
        $('#hu').button("refresh");
        $('#ip').removeAttr('checked');
        $('#ip').button("refresh");
        $('#hy').removeAttr('checked');
        $('#hy').button("refresh");
        $('#fr').removeAttr('checked');
        $('#fr').button("refresh");
        $('#cd').removeAttr('checked');
        $('#cd').button("refresh");
        $('#qfr').removeAttr('checked');
        $('#qfr').button("refresh");
        $('#wr').removeAttr('checked');
        $('#wr').button("refresh");
	$('#wr_profic_div').attr("style", "display:none");
	$('#profic_wint').removeAttr('checked');
	$('#profic_wint').button("refresh");
	$('#profic_wadv').removeAttr('checked');
	$('#profic_wadv').button("refresh");
	$('#profic_any').removeAttr('checked');
	$('#profic_any').button("refresh");

        $('#ddhu').removeAttr('checked');
        $('#ddhu').button("refresh");
        $('#cndp').removeAttr('checked');
        $('#cndp').button("refresh");

	$('#fc_fc').removeAttr('checked');
	$('#fc_fc').button("refresh");
	$('#fc_hc').removeAttr('checked');
	$('#fc_hc').button("refresh");
	$('#fc_cc').removeAttr('checked');
	$('#fc_cc').button("refresh");

        $('#module_mod1').removeAttr('checked');
        $('#module_mod1').button("refresh");
        $('#module_mod2').removeAttr('checked');
        $('#module_mod2').button("refresh");
        $('#module_full').removeAttr('checked');
        $('#module_full').button("refresh");
        $('#module_spec').removeAttr('checked');
        $('#module_spec').button("refresh");

        $('#monday').removeAttr('checked');
        $('#monday').button("refresh");
        $('#tuesday').removeAttr('checked');
        $('#tuesday').button("refresh");
        $('#wednesday').removeAttr('checked');
        $('#wednesday').button("refresh");
        $('#thursday').removeAttr('checked');
        $('#thursday').button("refresh");
        $('#friday').removeAttr('checked');
        $('#friday').button("refresh");
        $('#saturday').removeAttr('checked');
        $('#saturday').button("refresh");
        $('#sunday').removeAttr('checked');
        $('#sunday').button("refresh");

    });
});

  $(document).ready(function() {
  // Remove duplicate course descriptions info (leaves just the last one)
  $("tr.course_continued").prev("tr.descrip").each(function(index) {
    conflict_messages = $(this).find("span.course_conflict");
    // skip over the next item (should be a course_continued) to the next description
    my_description = $(this).next("tr.course_continued").next("tr.descrip").find("div.first_div div.first_div");

    // add the old messages to the next description block
    conflict_messages.each(function() {
      my_description.prepend( '<br>\n' );
      my_description.prepend( $(this) );
    });

    my_location = $(this).next("tr.course_continued").next("tr.descrip").find("span.location");
    oldHTML = my_location.html();
    my_location.html($(this).find("span.location").html() + '<br>' + oldHTML);

    // and now remove this description block
    $(this).remove();

  });
$("tr.evenconflict td.crn, tr.oddconflict td.crn").each(function(index) { 
  my_crn = $(this).text(); 
  $("tr.course_entry:has(td.crn:contains("+my_crn+"))").each(function() {
    $(this).addClass("conflict_continued");
  });
});

// Clear out fields that are duplicated in the previous line (same crn)
$("tr.course_continued td.chkbox").children().remove();
$("tr.course_continued td.crn").text('');
$("tr.course_continued td.dept").text('');
$("tr.course_continued td.cnum").text('');
$("tr.course_continued td.cname").text('');
$("tr.course_continued td.profes").text('');
$("tr.course_continued td.enroll").html('');
$("tr.course_continued td.profic").children().remove();

// turn id into class name and store for easy retrieval
$("tr.course_entry").each(function(index) {
  $(this).addClass($(this).attr("id"));
  $(this).attr("course_master_id", $(this).attr("id"));
});

// remove id from continued courses so that we only have one
$("tr.course_continued").each(function(index) {
  $(this).removeAttr("id");
});

// Delete uneeded rows for cancelled courses
$('tr.course_continued td.cancel_message').parent().remove();

// add click handler to all <td> in courses table other than checkbox and description row
var table_rows = 'tr.course_entry td:not(.chkbox)';

// Make it so that related rows all display hover behavior
$(table_rows).hover(function() {

    // currently 'hovered' is the same as 'selected', but we'll use a diff name for future fun
    $('.'+$(this).parent().attr('course_master_id')).toggleClass('hovered');

});

$(table_rows).click(function() {
    // get the number of the desc to show/hide
    var num = $(this).parent().attr('course_master_id').split('_')[1];

    // show/hide the desc
    $('#desc_'+num).toggle('fast');

    // hilight/unhilight clicked class row (and relevant neighbors)
    $('.'+$(this).parent().attr('course_master_id')).toggleClass('selected');
});
// -- add some floating title text to selected courses ------------------------
function isBlank(str) { return ( typeof str === 'undefined' || 0 === str.length || /^\s*$/.test(str)); }

jQuery.fn.add_title_text = function(new_text) {
  return this.each( function(index){
    // grab the old text
    var new_title = $(this).prop('title');

    // add some newlines if needed
    if ( ! isBlank(new_title) ) {
      new_title += "\n\n"; 
    }

    // add the new text and save it back
    new_title += new_text;
    $(this).prop('title', new_title);
  });
}

// Near capacity courses
$( 'tr.full td.chkbox, ' +
   'tr.full td.enroll' ).add_title_text("This class is at or above 80% of capacity");
// Course conflicts
$( 'tr.evenconflict td.days_off, ' +
   'tr.evenconflict td.time, '    +
   'tr.oddconflict td.days_off, ' +
   'tr.oddconflict td.time' ).add_title_text("This class meeting conflicts with something in your cart\n(click to see more information)");
// Already in the cart
$( 'tr.evenincart.course_entry td, ' +
   'tr.oddincart.course_entry  td'      ).add_title_text("This class is already in your cart");

// -- Hide courses functions ----------------------------------------
$('#hide_conflicts:checkbox').change(function(e) {
  i_am_checked = $(this).prop('checked');
  if (i_am_checked) {
    $('.conflict_continued').hide('fast').removeClass('hovered').removeClass('selected');
    $('.course_description span.course_conflict').closest('tr.descrip').hide('fast');
  } else {
    $('.conflict_continued').show('fast');
    //$('.course_description span.course_conflict').closest('tr.descrip').show('fast');
  }
});
});
