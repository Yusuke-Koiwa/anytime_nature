$(window).scroll(function() {
  if ($(window).scrollTop() < 10){ 
    $('#header').css('box-shadow', 'none');
    return; 
  }
  $('#header').css('box-shadow', '0px 2px 2px 1px rgba(51,48,0,0.4)');
})