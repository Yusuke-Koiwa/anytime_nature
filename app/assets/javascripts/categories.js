$(function(){

  function appendOption(category){
    let html = `<option value="${category.id}">
                  ${category.name}
                </option>`;
    return html
  }

  function appendChildrenSelection(insertHtml){
    let childrenSelectHtml = "";
    childrenSelectHtml = `<select class="select-default" id="children-categories" name="picture[category_id]">
                            <option value="">選択して下さい</option>
                            ${insertHtml}
                          </select>`;
    $(".category-input").append(childrenSelectHtml);
  }

  $(document).on("change", "#category-select", function(){
    let parentCategory = $("#category-select").val();
    if (parentCategory == "") {
      $("#children-categories").remove();
    } else {
      $.ajax({
        url: "/categories/children",
        type: "GET",
        data: {parentCategory: parentCategory},
        dataType: "json"
      })
      .done(function(children){
        let insertHtml = "";
        children.forEach(function(child){
          insertHtml += appendOption(child);
        });
        if ($("#children-categories").length) {
          $("#children-categories").remove();
        }
        appendChildrenSelection(insertHtml);
      })
      .fail(function(){
        alert("カテゴリーを取得出来ませんでした")
      })
    }
  });
});