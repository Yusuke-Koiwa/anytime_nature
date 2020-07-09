$(function(){

  $('#close-btn').on('click', function(){
    $('#edit-form').fadeOut();
  });

  $('#modal').on('click', function(){
    $('#edit-form').fadeOut();
  });

  $('#edit-btn').on('click', function(){
    $('#edit-form').fadeIn();
  });

});