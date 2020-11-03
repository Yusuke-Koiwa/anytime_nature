$(function(){
  $('#mypage-link').hover(function(){
    $('#mypage-menu').show();
  }, function(){
    $('#mypage-menu').hide();
  });

  $('#mypage-menu').hover(function(){
    $('#mypage-menu').show();
  }, function(){
    $('#mypage-menu').hide();
  });

  $('.nav_toggle').on('click', function(){
    $('.nav_toggle, nav').toggleClass('show')
  })
});