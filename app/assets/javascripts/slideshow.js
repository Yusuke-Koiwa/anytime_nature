$(function() {

  if ($('#slideshow-contents').length) {
    $('#slideshow-contents').slick({
        dots: true,
        autoplay: false,
        autoplaySpeed: 3000,
        infinite: true,
        speed: 500,
        fade: true,
        cssEase: 'linear',
        prevArrow: '<div class="slide-arrow prev-arrow"><i class="fa fa-arrow-circle-left"></i></div>',
        nextArrow: '<div class="slide-arrow next-arrow"><i class="fa fa-arrow-circle-right"></div>'
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