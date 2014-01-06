tinymce.PluginManager.add 'mediabrowser', (editor, url) ->
  editor.addButton 'mediabrowser',
    text: 'Browse'
    icon: false
    onclick: -> window.open("/admin/mediabrowser", "_blank", "toolbar=yes, scrollbars=yes, resizable=yes, top=0, left=600, width=600, height=700")
      # editor.windowManager.open
      #   title: 'Media Browser'
      #   body: [{type: 'textbox', name: 'title', label: 'Title'}]
      #   onsubmit: (e) -> editor.insertContent('Title: ' + e.data.title)
