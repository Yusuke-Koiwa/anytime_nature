$(function(){
  $('.picture').hover(function(){
    $(this).children('.picture-info').addClass('visible');
  }, function(){
    $(this).children('.picture-info').removeClass('visible');
  });
});