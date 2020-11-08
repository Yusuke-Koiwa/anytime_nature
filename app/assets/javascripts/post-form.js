$(function(){

  function appendOption(category){
    let html = `<option value="${category.id}">
                  ${category.name}
                </option>`;
    return html
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
});