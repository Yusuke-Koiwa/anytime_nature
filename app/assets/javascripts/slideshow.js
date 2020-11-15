$(function() {
  const slideshowContentsID = $('#slideshow-contents');
  if (slideshowContentsID.length) {
  const playBtnID = $('#play-btn');
  const stopBtnID = $('#stop-btn');

    slideshowContentsID.slick({
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
      slideshowContentsID.slick('goTo', $(this).index());
    });
  
    playBtnID.on('click', function(){
      playBtnID.hide();
      stopBtnID.show();
      slideshowContentsID.slick('slickPlay');
    });
  
    stopBtnID.on('click', function(){
      stopBtnID.hide();
      playBtnID.show();
      slideshowContentsID.slick('slickPause');
    });
  }
});