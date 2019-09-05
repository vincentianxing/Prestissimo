// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


// Remove all time slots before first class and after last class
$(function() {
  function trimCalendar() {
    var start;
    var end;
    $(".wc-time").each(function() {
      var time = $(this).html().slice(0, 8);
      time = Date.parse("08/19/2013 " + time);
      if(!start || start > time) {
        start = time;
      }
      if(!end || end < time) {
        end = time;
      }
    });
    console.log(start);
    console.log(end);
  }
});
