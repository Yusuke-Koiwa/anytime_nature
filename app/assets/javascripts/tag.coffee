$(document).on 'ready page:load', ->
  if $('#picture-tags').length
    $('#picture-tags').tagit
      fieldName:   'tag_list'
      singleField: true
      availableTags: $("#all_tags_hidden").val().split(' ')
    $('#picture-tags').tagit()
    $('.ui-autocomplete-input').attr('maxlength', 20)
    tag_string = $("#tag_hidden").val()
    try
      tag_list = tag_string.split(',')
      for tag in tag_list
        $('#picture-tags').tagit 'createTag', tag
    catch error