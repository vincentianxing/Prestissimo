// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {
    function createCookie(name,value,days) {
        if (days) {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            var expires = "; expires="+date.toGMTString();
        }
        else var expires = "";
        document.cookie = name+"="+value+expires+"; path=/";
    }

    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }

    function eraseCookie(name) {
        createCookie(name,"",-1);
    }

    // attatch a function to the load cart button
    // so that it sets a cookie to tell the site to
    // load the cart after redirecting home
    var lc = document.getElementById('load_cart');
    lc.onclick = setLoadCookie;

    // function to set a cookie when the cart needs to be loaded
    function setLoadCookie() {
      // test if on homepage before setting cookie.
      if((window.location.origin != window.location.href) && (window.location.origin + "/" != window.location.href)){
        var d = new Date();
        d.setTime(d.getTime + (24*60*60*1000)); //Cookie expires in one day
        var expires = "expires="+d.toUTCString();
        document.cookie = "load_cart=true; " + expires + "; path=/";
      }
    }


    $( "#cart_container" )
        .css({
            top: readCookie("cartY")*1,
            left: readCookie("cartX")*1 })
        .draggable({
            //stack: "div",
            containment: "window",
            stop: function (event, ui) {
                if (ui.position.left > $(window).width() || ui.position.left < 0) {
                  ui.position.left = 0;
                }
                if (ui.position.top > $(window).height() || ui.position.top < 0) {
                  ui.position.top = 0;
                }
                createCookie("cartX", ui.position.left, 100);
                createCookie("cartY", ui.position.top, 100);
            } });

    // make sure the cart doesn't get too big or too small for the window.
    $( "#courses_scroller" ).css({ "max-height": ($(window).height()) * 0.6 - 100});
    $(window).resize(function() {
        $( "#courses_scroller" ).css({ "max-height": ($(window).height()) * 0.6 - 100});
        var count = $( ".courses tr.cart_course" ).length;
        if ( count < 4 ) {
          $( "#courses_scroller" ).css({ "min-height": $(".courses").height() });
        } else {
          $( "#courses_scroller" ).css({ "min-height": 100 });
        }
    });

    var $mailer_dialog = $('#cart_mailer_dialog').dialog({
        autoOpen: false,
        title: 'Email Courses',
        resizable: false,
        modal: true,
        draggable: true,
        closeText: "X",
        width: 350
    });
  $('#mail_cart_link').click(function(){
    $mailer_dialog.dialog('open');
  });
  // show the info of a clicked course
  var box_id = "";

    $("body").on("click", "td.car_inf", function() {

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


    $('#minimize_cart').tooltip({ content: "Minimize Cart"});
    $('#minimized_cart').tooltip({ content: "Maximize Cart"});

    // makes sure the cart is minimized or maximized according to the cartMin cookie
    if (readCookie("cartMin") == "true"){
      $("#cart_container").hide();
      $("#minimized_cart").show();
    }
    else {
      $("#cart_container").show();
      $("#minimized_cart").hide();
    }

    // minimizes the cart, and creates a cookie, cartMin, to keep it that way
    $('#minimize_cart').click(function(){
      createCookie("cartMin","true",100);
      $("#cart_container").hide();
      $("#minimized_cart").show();

    });

    // maximizes the cart, and deletes the cookie that keeps it that way
    $('#minimized_cart').click(function(){
      eraseCookie("cartMin");
      $("#cart_container").show();
      $("#minimized_cart").hide();
    });
//    $('#cart_container').animate({left: '220px'});
});
