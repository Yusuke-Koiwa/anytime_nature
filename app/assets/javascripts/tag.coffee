$(document).on 'ready page:load', ->
  $('#picture-tags').tagit
    fieldName:   'tag_list'
    singleField: true
  $('#picture-tags').tagit()
  $('.ui-autocomplete-input').attr("placeholder", "タグを入力")
  tag_string = $("#tag_hidden").val()
  try
    tag_list = tag_string.split(',')
    for tag in tag_list
      $('#picture-tags').tagit 'createTag', tag
  catch error