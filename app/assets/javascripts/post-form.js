$(function(){
  const categorySelectID = $('#category-select');
  const childrenCategoriesID = $('#children-categories');
  const mainCategoryID = $('#main-category');
  const subCategoryID = $('#sub-category');
  const picSubmitBtn = $('#pic-submit-btn');
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
    if (categorySelectID.val() == "") {
      let message = "メインカテゴリーを選択して下さい";
      appendErrorMessage(mainCategoryID, message);

      return errorCount + 1;
    }
    if (childrenCategoriesID.val() == "") {
      let message = "サブカテゴリーを選択して下さい";
      appendErrorMessage(subCategoryID, message);

      return errorCount + 1;
    }

    return errorCount;
  }

  function appendErrorMessage(el, message){
    let errorMessage = `<div class="error-message">${message}</div>`
    el.append(errorMessage);
  }

  $(document).on("change", "#category-select", function(){
    let parentCategory = categorySelectID.val();
    if (parentCategory == "") {
      childrenCategoriesID.empty();
      let insertHtml = '<option value="">選択して下さい</option>';
      childrenCategoriesID.append(insertHtml);

      return;
    }
    $.ajax({
      url: "/categories/children",
      type: "GET",
      data: {parentCategory: parentCategory},
      dataType: "json"
    })
    .done(function(children){
      childrenCategoriesID.empty();
      let insertHtml = '<option value="">選択して下さい</option>';
      children.forEach(function(child){
        insertHtml += appendOption(child);
      });
      childrenCategoriesID.append(insertHtml);
    })
    .fail(function(){
      alert("カテゴリーを取得出来ませんでした")
    })
  });

  picSubmitBtn.on('click', function(e){
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
      picSubmitBtn.trigger('click');
    }
  })
});