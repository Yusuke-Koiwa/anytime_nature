$(function() {
  $('#slideshow-contents').slick({
      dots: true,
  });

  $('.slick-dots li').on('mouseover', function() {
    $('#slideshow-contents').slick('goTo', $(this).index());
  });
});