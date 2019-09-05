
$(document).ready(function(){

  //Show/Hide department links on hubcourse search page in mobile format
  //This has the unbind method attached because the click event was being fired twice,
  // and this was given as a possible solution!
  $('#dept_menu_button').unbind('click').click(function(){
      $('#dept_menu_list').slideToggle(150);
      if ($('#dept_menu_button').jqmData('icon') == 'arrow-d'){
	$('#dept_menu_button').buttonMarkup({icon: 'arrow-u'});
      }
      else{
	$('#dept_menu_button').buttonMarkup({icon: 'arrow-d'});
      }
  });

});
