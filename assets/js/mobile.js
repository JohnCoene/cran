$(document).on('shiny:sessioninitialized', function() {
  Shiny.setInputValue('screen_width', screen.width);
});