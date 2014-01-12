# angular
#   .module('FormEditorApp')
#   .directive('infoField', ['$document', ($document) ->
#     restrict: 'C'
#     templateUrl: 'info-field.html'
#     replace: true
#     # scope:
#     #   files: '='
#     #   path: '='
#     link: (scope, el, attr) ->

#       # uploadQueue = []
#       # uploadsInProgress = 0
#       # maxSimultaneousUploads = 3
#       # csrf_token = $cookies['XSRF-TOKEN']

#       # $document.on 'dragover', (evt) ->
#       #   evt.preventDefault()
#       #   evt.stopPropagation()
#       #   evt.originalEvent.dataTransfer.effectAllowed = 'copy'
#       #   evt.originalEvent.dataTransfer.dropEffect = 'copy'
#       # $document.on 'drop', (evt) ->
#       #   evt.preventDefault()
#       #   evt.stopPropagation()
#       #   addFilesToQueue(evt.originalEvent.dataTransfer.files)
#       # input = el.find('input[type=file]')
#       # input.bind 'change', (evt) -> addFilesToQueue(evt.target.files)
#       # el.find('button').on 'click', -> input.click()

#   ])
