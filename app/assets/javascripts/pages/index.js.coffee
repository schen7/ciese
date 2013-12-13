//= require angular/angular.min
//= require_self
//= require_directory .

try
  angular.module('PageEditorApp')
catch error
  angular
    .module('PageEditorApp', [])
    .config(['$locationProvider', ($locationProvider) ->
      $locationProvider.html5Mode(true)
    ])
    .run(['$rootScope', ($rootScope) ->
      editor = new tinymce.Editor("content-editor",
        selector: "#content-editor"
        plugins: [
          ["advlist autolink link image lists charmap print preview hr anchor "],
          ["pagebreak spellchecker searchreplace wordcount visualblocks"],
          ["visualchars code fullscreen insertdatetime media nonbreaking"],
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
      , tinymce.EditorManager)

      editor.on('change', -> $rootScope.$digest())
      editor.on('blur', -> $rootScope.$digest())
      editor.on('PreInit', -> editor.load())
      editor.render()

      $rootScope.contentEditor = editor
    ])

angular.element(document).ready ->
  angular.bootstrap(angular.element('#page-editor'), ['PageEditorApp'])
