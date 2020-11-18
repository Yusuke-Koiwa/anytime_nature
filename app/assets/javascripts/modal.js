$(function(){
  const editFormID = $('#edit-form');
  if (editFormID.length) {
    const modal = $('#modal');
    const closeBtn = $('#close-btn');
    const editBtn = $('#edit-btn');
  
    closeBtn.on('click', function(){
      editFormID.fadeOut();
    });
  
    modal.on('click', function(){
      editFormID.fadeOut();
    });
  
    editBtn.on('click', function(){
      editFormID.fadeIn();
    });
  }
});