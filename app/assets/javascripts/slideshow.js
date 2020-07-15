$(function() {

  if ($('#slideshow-contents').length) {
    $('#slideshow-contents').slick({
        dots: true,
        autoplay: false,
        autoplaySpeed: 3000,
        infinite: true,
        speed: 500,
        fade: true,
        cssEase: 'linear'
    });
  
    $('.slick-dots li').on('mouseover', function() {
      $('#slideshow-contents').slick('goTo', $(this).index());
    });
  
    $('#play-btn').on('click', function(){
      $('#play-btn').hide();
      $('#stop-btn').show();
      $('#slideshow-contents').slick('slickPlay');
    });
  
    $('#stop-btn').on('click', function(){
      $('#stop-btn').hide();
      $('#play-btn').show();
      $('#slideshow-contents').slick('slickPause');
    });
  }

});