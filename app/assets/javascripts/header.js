$(function() {
  const headerID = $('#header');
  let basePosition = $(window).scrollTop();

  $(window).scroll(function() {
  let currentPosition = $(window).scrollTop();
    if (currentPosition < 10){ 
      headerID.removeClass('header-shaddow');
      basePosition = currentPosition;

      return; 
    }

    if (currentPosition > basePosition) {
      headerID.addClass('header-hide').removeClass('header-shaddow');
      basePosition = currentPosition;

      return;
    }
    headerID.removeClass('header-hide').addClass('header-shaddow');
    basePosition = currentPosition;
  })
});