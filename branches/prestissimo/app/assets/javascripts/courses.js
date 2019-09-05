//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



// click handler for show/hide search button
function moreClick(){
  $('#adv_search').slideToggle(150, function() {
    if ($('#adv_search').css('display') != 'none') {
      $('#adv_link').text('less');
      $('#search_help').animate({ height: '260px' }, 50);
    }
    else {
      $('#adv_link').text('more');
      $('#search_help').animate({ height: '100px' }, 50);
    }
  });
}


$(document).ready(function() {

  var search_choice = true;

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
    var form = document.forms["sf"];
    var justsem = true;
    var checkboxes = new Array("cd", "wr", "qp", "monday", "tuesday",
      "wednesday", "thursday", "friday", "saturday",
      "sunday", "mod1", "mod2", "full", "special",
      "ns", "ss", "hu");
    var arrayspot = 0;
    for (i=0; i<form.elements.length - 2; i++){
      var title = form.elements[i].name;
      var value = form.elements[i].value;
      if (title!=undefined && title.length > 0){
	if (title != "utf8" && title != "cart_id"  && title != "semester"){
	  if (title == checkboxes[arrayspot]){
	    arrayspot++;
	    if (document.getElementById(title).checked){
	      justsem = false;
	    }
	  }
	  else if (value.length > 0){
	    justsem = false;
	  }
	}
      }
    }
    if (justsem){
      var response = confirm("This search will return every course offered in the specified semester. It will take a few moments to finish...are you sure you'd like to carry out this search?");
      if (!response){
	search_choice = false;
	return false;
      }
      else{
	search_choice = true;
      }

    }
    else{
      search_choice = true;
    }
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

  jQuery.ajax({
    url: '/hide_search'
  });

  //this is the text that will appear in the hover boxes
  var form_helpers_hover = new Array();

  ////////////////////////////
  ///form_helpers_hover//////
  ////////////////////////////
  
  form_helpers_hover['cname'] = 'The Course Name field filters results by their titles.'
    + ' Search results will have titles that match the query.'
    + '\n For example, searching either "Principles" or "Principles of Computer Science" will return the course "Principles of Computer Science"';

  form_helpers_hover['professor'] = 'The Professor field returns courses being taught by a professor whose name matches or contains the search phrase.'
    + '\nNames are in First Last format.';

  form_helpers_hover['dept'] = 'The Department selector returns courses  being offered by the specified department.'
    + '\nAll courses are displayed, including Private Readings and Honors listings.';

  form_helpers_hover['semester'] = 'The Semester selector determines which catalog to search.'
    + ' The most recently available catalog is the top option.'
    + '\n\nNote: most course catalogs become available midway through the preceding semester, and Prestissimo updates to the new catalog at this time.'
    + ' Check to make sure you are searching in the preferred semester.\n';

  form_helpers_hover['proficiencies'] = 'The Proficiencies boxes allow for filtering classes by which requirements they fulfill.'
    + ' Checking one box will return classes that offer credit for that proficiency,'
    + ' and checking more than one box will return classes that offer all of the selected proficiencies.'
    + '\nFor example, if both CD and WR are checked, only courses that give both CD and WR will be returned.'
    + '\n\nThe abbreviations are:\n'
    + 'CD: Cultural Diversity'
    + '\nWR: Writing Proficiency'
    + '\nQP: Quantitive Proficiency';

  form_helpers_hover['days'] = 'The Days boxes restrict results to the selected days.'
    + ' Checking a day will show all courses that run on that day. Selecting more than one day will show courses offered on both of those days.'
    + '\nFor example, if Class A runs on MW, and Class B runs on MWF, then checking M and W will return A and B,'
    + ' but checking M, W, and F will return only class B.';

  form_helpers_hover['modules'] = 'The Modules boxes filter courses by which module of the semester they are offered in.'
    + '\n\nFirst Module runs from the start of the semester until the week of break,'
    + ' second module runs from the week of break until the end of the semester,'
    + ' and special indicates a class with various meeting times.\n'
    + 'All other classes are full semester classes.';

  form_helpers_hover['attributes'] = 'The Attributes boxes restrict classes to the selected attributes.'
    + ' If one attribute is checked, courses in that field will be shown;'
    + ' if more than one attribute is selected, then only courses with both of those attributes will be shown.'
    + '\n\nThe abbreviations are:\n'
    + 'NS: Natural Sciences'
    + '\nSS: Social Sciences'
    + '\nHU: Arts & Humanities.';

  form_helpers_hover['credits'] = 'The Credit fields limit results to the specified credit range.'
    + '\nIf the Min field is filled, courses that offer at least that number of credits are shown.'
    + ' If the Max field is filled, courses with at most that number of credits are shown.'
    + ' When both Min and Max are filled, results will fall into that range, inclusive.'
    + '\nSearches where Min is higher than Max will not return anything.';

  form_helpers_hover['crn'] = 'The CRN field searches for courses with a CRN that matches or contains the query.'
    + '\nSearching for "519" would return all courses whose CRNs contain 519, as well as the course with the CRN 519.';

  form_helpers_hover['start'] = 'The "Start After" field allows you to specify the start time of a course.'
    + '\nIf a start time is specified and an end time is not, results will all be courses that start at exactly that time.'
    + '\n\nIf both start and end time are filled, results will be courses in the time range, but that may not start and end at exactly those times.\n'
    + 'The hour field must be filled when searching.'
    + ' Minutes are optional and assumed to be 00 when not chosen.'
    + ' Minutes cannot be searched without an hour.';

  form_helpers_hover['end'] = 'The "End Before" field allows you to specify the end time of a course.'
    + '\nIf an end time is chosen and a start time is not, results will be courses that end at exactly that time.'
    + '\n\nIf both start and end time are filled, results will be courses in the time range, but that may not start and end at exactly those times.\n'
    + 'The hour field must be filled when searching.'
    + ' Minutes are optional and assumed to be 00 when not chosen.'
    + ' Minutes cannot be searched without an hour.';

  form_helpers_hover['level'] = 'The Course Level selectors search by course number.'
    + '\nThe first selector chooses the comparator, and the second chooses level.'
    + '\nGreater Than finds courses with numbers at least as high as the level,'
    + ' Less Than finds courses at most the selected level,'
    + ' and Equal To finds courses with numbers in that level range.'
    + '\nIf no comparator is specified, Equal To is assumed. If no number is chosen, this field is not searched.';

  form_helpers_hover['date'] = 'Any courses modified since the given date (e.g. a course\'s location, time, professor) are found.'
    + '\nSelecting only the day finds the courses changed since the given day in the current month and year.'
    + '\nSelecting only the month finds the courses changed since the beginning of the given month.'
    + '\nSelecting only the year finds the couses changed since January 1 of the given year.'
    + '\nSelecting a day and month without a year finds the courses changed since the month and day in the current year.';

    $('.search_label').hover(function() {
      var helper_id = $(this).parent().attr('id').split('_')[0];
      $(this).parent().attr('title', form_helpers_hover[helper_id]);
    });

    $('.search_tag:input').hover(function() {
      var helper_id = $(this).parent().attr('id').split('_')[0];
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
});

