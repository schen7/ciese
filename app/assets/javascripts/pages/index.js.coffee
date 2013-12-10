urlDirty = false
contentDirty = false
urlEditor = $("#url-editor")
contentEditor = null
saveButton = $("#save-button")
publishButton = $("#publish-button")

checkUrlDirty = ->
  urlDirty = urlEditor.val() isnt urlEditor.data("original")
  updateButtons()

checkContentDirty = ->
  contentDirty = contentEditor.isDirty()
  updateButtons()

updateButtons = ->
  dirty = urlDirty or contentDirty
  saveButton.attr("disabled", not dirty)
  publishButton.attr("disabled", dirty)

clearDirty = ->
  urlEditor.data("original", urlEditor.val())
  urlDirty = false
  contentEditor.isNotDirty = true
  contentDirty = false
  updateButtons()

saveDone = (data, status, jqXHR) ->
  if not data.saved
    saveError(jqXHR, status, data.errors)
  clearDirty()

saveError = (jqXHR, status, error) ->
  alert("An error occurred during save. The page was not saved. Error: #{error}")

$(document).on 'ready page:load', ->
  tinymce.init
    selector: "#content-editor"
    plugins: [
      ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker"],
      ["searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking"],
      ["save table contextmenu directionality emoticons template paste"]
    ]
    theme: "modern"
    add_unload_trigger: false
    schema: "html5"
    inline: true
    toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | media"
    relative_urls: false
    remove_script_host: true
    document_base_url: "http://ciese.org/"
    statusbar: false
    setup: (editor) ->
      contentEditor = editor
      editor.on('change', checkContentDirty)
      editor.on('blur', checkContentDirty)

  urlEditor.data("original", urlEditor.val())
  urlEditor.on("keyup", checkUrlDirty)

  saveButton.on "click", (evt) ->
    evt.preventDefault()
    data =
      url: urlEditor.val()
      content: contentEditor.getContent()
    $.ajax
      type: "POST"
      url: "/admin/pages"
      data: data
      success: saveDone
      error: saveError
      dataType: "json"
    saveButton.attr("disabled", true)

