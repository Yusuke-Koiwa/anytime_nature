$(function(){
  function buildHTML(image) {
    let html = `
              <div class="prev-content">
                <img src="${image}", alt="preview" class="prev-image">
              </div>
              `
    return html;
  }

  $(document).on('change', '.file-input', function(){
    let file = this.files[0];
    let reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(){
      let image = this.result;
      if ($('.prev-content').length == 0) {
        let html = buildHTML(image)
        $('.prev-contents').append(html);
        $('.default-prev').hide();
      } else {
        $('.prev-content .prev-image').attr({ src: image });
      }
    }
  });
});