$(function(){
  let preventSubmit = true;

  function appendOption(category){
    let html = `<option value="${category.id}">
                  ${category.name}
                </option>`;
    return html
  }

  function checkUpload(errorCount) {
    if ($('.prev-content').length >= 1) {

      return errorCount;
    }
    let el = $('.image_label').parent('.field__input');
    let message = "画像をアップロードして下さい";
    appendErrorMessage(el, message);
    return errorCount + 1;
  }

  function checkCategory(errorCount) {
    if ($('#category-select').val() == "") {
      let el = $('#main-category');
      let message = "メインカテゴリーを選択して下さい";
      appendErrorMessage(el, message);

      return errorCount + 1;
    }
    if ($('#children-categories').val() == "") {
      let el = $('#sub-category');
      let message = "サブカテゴリーを選択して下さい";
      appendErrorMessage(el, message);

      return errorCount + 1;
    }

    return errorCount;
  }

  function appendErrorMessage(el, message){
    let errorMessage = `<div class="error-message">${message}</div>`
    el.append(errorMessage);
  }

  $(document).on("change", "#category-select", function(){
    let parentCategory = $("#category-select").val();
    if (parentCategory == "") {
      $("#children-categories").empty();
      let insertHtml = '<option value="">選択して下さい</option>';
      $('#children-categories').append(insertHtml);

      return;
    }
    $.ajax({
      url: "/categories/children",
      type: "GET",
      data: {parentCategory: parentCategory},
      dataType: "json"
    })
    .done(function(children){
      $('#children-categories').empty();
      let insertHtml = '<option value="">選択して下さい</option>';
      children.forEach(function(child){
        insertHtml += appendOption(child);
      });
      $('#children-categories').append(insertHtml);
    })
    .fail(function(){
      alert("カテゴリーを取得出来ませんでした")
    })
  });

  $('#pic-submit-btn').on('click', function(e){
    if (preventSubmit === true) {
      e.preventDefault();
      $('.error-message').each(function() {
        $(this).remove();
      });
      let errorCount = 0;
      errorCount = checkUpload(errorCount);
      errorCount = checkCategory(errorCount);
      if (errorCount !== 0) {

        return;
      }
      preventSubmit = false;
      $('#pic-submit-btn').trigger('click');
    }
  })
});