$(function(){
  if ($('#post').length === 0) {
    return;
  }
  const categorySelectID = $('#category-select');
  const childrenCategoriesID = $('#children-categories');
  const mainCategoryID = $('#main-category');
  const subCategoryID = $('#sub-category');
  const picSubmitBtn = $('#pic-submit-btn');
  let preventSubmit = true;

  function fetchChildrenCategories(parentCategoryVal) {
    $.ajax({
      url: "/categories/children",
      type: "GET",
      data: {parentCategory: parentCategoryVal},
      dataType: "json"
    })
    .done(function(children){
      categorySelectID.addClass('selected');
      appendChildrenCategories(children);
    })
    .fail(function(){
      alert("カテゴリーを取得出来ませんでした");
    })
  }

  function appendChildrenCategories(children) {
    childrenCategoriesID.empty().removeClass('selected');
    let insertHtml = '<option value="">選択して下さい</option>';
    children.forEach(function(child){
      insertHtml += appendOption(child);
    });
    childrenCategoriesID.append(insertHtml);
  }

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

  $(window).load(function() {
    let parentCategoryVal = categorySelectID.val();
    if (parentCategoryVal !== "") {
      categorySelectID.addClass('selected');
      fetchChildrenCategories(parentCategoryVal);
    }
  })

  categorySelectID.on("change", function(){
    let parentCategoryVal = categorySelectID.val();
    if (parentCategoryVal == "") {
      categorySelectID.removeClass('selected');
      childrenCategoriesID.empty().removeClass('selected');
      let insertHtml = '<option value="">選択して下さい</option>';
      childrenCategoriesID.append(insertHtml);

      return;
    }
    fetchChildrenCategories(parentCategoryVal);
  });

  childrenCategoriesID.on('change', function() {
    if (childrenCategoriesID.val() !== "") {
      childrenCategoriesID.addClass('selected');
    } else {
      childrenCategoriesID.removeClass('selected');
    }
  })

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