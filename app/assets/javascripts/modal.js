$(function(){
  const modal = $('#modal');
  const closeBtn = $('#close-btn');
  const editBtn = $('#edit-btn');
  const editFormID = $('#edit-form');

  closeBtn.on('click', function(){
    editFormID.fadeOut();
  });

  modal.on('click', function(){
    editFormID.fadeOut();
  });

  editBtn.on('click', function(){
    editFormID.fadeIn();
  });

});