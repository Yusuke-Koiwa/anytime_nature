$(function(){
  $('#mypage-link').hover(function(){
    $('#mypage-menu').addClass('show');
  }, function(){
    $('#mypage-menu').removeClass('show');
  });

  $('#mypage-menu').hover(function(){
    $('#mypage-menu').addClass('show');
  }, function(){
    if (!($('.nav_toggle').hasClass('show'))) {
      $('#mypage-menu').removeClass('show');
    }
  });

  $('.nav_toggle').on('click', function(){
    $('.nav_toggle, #mypage-menu').toggleClass('show');
  });
});