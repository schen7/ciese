angular
  .module('MediaBrowserApp')
  .directive 'uploader', ['$document', '$cookies', ($document, $cookies) ->
    restrict: 'A'
    templateUrl: 'file_uploader.html'
    replace: true
    scope:
      files: '='
      path: '='
    link: (scope, el, attr) ->

      uploadQueue = []
      uploadsInProgress = 0
      maxSimultaneousUploads = 3
      csrf_token = $cookies['XSRF-TOKEN']

      $document.on 'dragover', (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        evt.originalEvent.dataTransfer.effectAllowed = 'copy'
        evt.originalEvent.dataTransfer.dropEffect = 'copy'
      $document.on 'drop', (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        addFilesToQueue(evt.originalEvent.dataTransfer.files)
      input = el.find('input[type=file]')
      input.bind 'change', (evt) -> addFilesToQueue(evt.target.files)
      el.find('button').on 'click', -> input.click()

      updateProgress = (file, progress, total) ->
        scope.$apply -> file.progress = progress / total * 100

      completeUpload = (file, response) ->
        scope.$apply ->
          file.uploading = false
          if response.image
            file.image = response.image
            file.thumb_url = response.thumb_url
        uploadsInProgress--
        checkQueue()

      checkQueue = ->
        if uploadsInProgress < maxSimultaneousUploads and uploadQueue.length > 0
          uploadNextFile()

      uploadNextFile = ->
        uploadsInProgress++
        file = uploadQueue.shift()
        formData = new FormData()
        formData.append('path', scope.path)
        formData.append('file', file.localFile)
        xhr = new XMLHttpRequest()
        xhr.open('POST', "/api/mediabrowser/upload", true)
        xhr.setRequestHeader("X-XSRF-TOKEN", csrf_token)
        xhr.upload.onprogress = (evt) ->
          updateProgress(file, evt.loaded, evt.total)
        xhr.onload = (evt) ->
          completeUpload(file, angular.fromJson(evt.target.response))
        xhr.send(formData)
        checkQueue()

      addFilesToQueue = (files) ->
        for localFile in files
          file =
            type: 'file'
            localFile: localFile
            name: localFile.name
            url: "/media/#{scope.path}/#{localFile.name}".replace(/\/\/+/g, '/')
            size: localFile.size
            modified: localFile.lastModifiedDate
            progress: 0
            uploading: true
          scope.$apply ->
            scope.files = (f for f in scope.files when f.name isnt file.name)
            scope.files.push(file)
          uploadQueue.push(file)
        checkQueue()

  ]
