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

      input = el.find('input[type=file]')
      csrf_token = $cookies['XSRF-TOKEN']

      updateProgress = (file, progress, total) ->
        scope.$apply -> file.progress = progress / total * 100

      uploadFile = (upload) ->
        file =
          type: 'file'
          name: upload.name
          path: "/media/#{scope.path}/#{upload.name}".replace(/\/\/+/g, '/')
          size: upload.size
          modified: upload.lastModifiedDate
          progress: 0
          uploading: true
        scope.$apply ->
          scope.files.push(file)

        formData = new FormData()
        formData.append('path', scope.path)
        formData.append('file', upload)

        xhr = new XMLHttpRequest()
        xhr.open('POST', "/api/mediabrowser/upload", true)
        xhr.setRequestHeader("X-XSRF-TOKEN", csrf_token)
        xhr.upload.onprogress = (evt) ->
          scope.$apply ->
            file.progress = evt.loaded / evt.total * 100 if evt.lengthComputable
        xhr.upload.onload = (evt) ->
          scope.$apply ->
            file.uploading = false
        xhr.send(formData)

      input.bind 'change', (evt) ->
        uploadFile(upload) for upload in evt.target.files

  ]
