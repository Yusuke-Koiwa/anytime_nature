$(function(){
  const pictureClass = $('.picture');

  pictureClass.hover(function(){
    $(this).children('.picture-info').addClass('visible');
    $(this).find('.picture-image').addClass('zoom-in');
  }, function(){
    $(this).children('.picture-info').removeClass('visible');
    $(this).find('.picture-image').removeClass('zoom-in');
  });
});