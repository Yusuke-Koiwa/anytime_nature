$(function(){
  const flashID = $('#flash');
  if (flashID) {
    setTimeout(function(){
      flashID.fadeOut();
    }, 2000)
  }
});