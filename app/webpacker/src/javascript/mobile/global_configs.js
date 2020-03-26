// this is where we can set jquery mobile global configs.
$(document).on("mobileinit", function(){
  $.extend( $.mobile , {
    // allows us to turn off ajax linking so that new pages are actually loaded as such
    ajaxEnabled:false,
    ignoreContentEnabled: true,
    // makes the default transition not be obnoxious
    defaultPageTransition: 'none'
  });
});
