angular
  .module('MediaBrowserApp')
  .directive 'uploader', ['$cookies', ($cookies) ->
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
      input = el.find('input[type=file]')
      csrf_token = $cookies['XSRF-TOKEN']

      updateProgress = (file, progress, total) ->
        scope.$apply -> file.progress = progress / total * 100

      uploadNextFile = ->
        if uploadsInProgress < maxSimultaneousUploads and uploadQueue.length > 0
          uploadsInProgress++
          file = uploadQueue.shift()
          formData = new FormData()
          formData.append('path', scope.path)
          formData.append('file', file.localFile)
          xhr = new XMLHttpRequest()
          xhr.open('POST', "/api/mediabrowser/upload", true)
          xhr.setRequestHeader("X-XSRF-TOKEN", csrf_token)
          xhr.upload.onprogress = (evt) ->
            scope.$apply ->
              file.progress = evt.loaded / evt.total * 100 if evt.lengthComputable
          xhr.upload.onload = (evt) ->
            scope.$apply ->
              file.uploading = false
            uploadsInProgress--
            uploadNextFile()
          xhr.send(formData)
          uploadNextFile()

      input.bind 'change', (evt) ->
        for localFile in evt.target.files
          file =
            type: 'file'
            localFile: localFile
            name: localFile.name
            path: "/media/#{scope.path}/#{localFile.name}".replace(/\/\/+/g, '/')
            size: localFile.size
            modified: localFile.lastModifiedDate
            progress: 0
            uploading: true
          scope.$apply ->
            scope.files.push(file)
          uploadQueue.push(file)
        uploadNextFile()

  ]
