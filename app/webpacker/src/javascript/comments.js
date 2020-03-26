// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready( function() {
	$('.comm_display_link').click( function() {
		var body_id = "#" + $(this).attr('id').split("_")[0] + "_body";
		$(body_id).addClass('hidden_para');
	});
});
