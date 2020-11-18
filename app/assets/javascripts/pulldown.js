$(function(){
  const mypageLinkID = $('#mypage-link');
  const mypageMenuID = $('#mypage-menu');
  const navToggleID = $('#nav_toggle');

  mypageLinkID.hover(function(){
    mypageMenuID.addClass('show');
  }, function(){
    mypageMenuID.removeClass('show');
  });

  mypageMenuID.hover(function(){
    mypageMenuID.addClass('show');
  }, function(){
    if (!(navToggleID.hasClass('show'))) {
      mypageMenuID.removeClass('show');
    }
  });

  navToggleID.on('click', function(){
    navToggleID.toggleClass('show');
    mypageMenuID.toggleClass('show');
  });
});