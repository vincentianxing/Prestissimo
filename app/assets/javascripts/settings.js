// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready(function(){
  function motd_live_prev(){
    var input = $("#motd_field").val();
    $("#motd_preview").html(input.substr(0,255));
  }

  $("#motd_field").keyup(function(){
    motd_live_prev();
  });
});

