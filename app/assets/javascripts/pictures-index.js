$(function() {
  const picturesIndex = $('.pictures-index');
  if (picturesIndex.length) {

    const pictureClass = $('.picture');

    function changePicturesHeight() {
      let pictureWidth = pictureClass.width();
      picturesIndex.css('grid-auto-rows', pictureWidth * 0.7);
    }

    $(window).resize(function() {
      changePicturesHeight();
    })

    changePicturesHeight();
  }
});