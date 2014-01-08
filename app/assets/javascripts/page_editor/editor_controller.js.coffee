angular
  .module('PageEditorApp')
  .controller('PageEditorCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
    angular.extend $scope,
      isDirty: ->
        titleDirty = $scope.pageForm.title.$dirty
        urlDirty = $scope.pageForm.url.$dirty
        editor = $scope.contentEditor
        if editor.initialized
          contentDirty = editor.startContent isnt editor.getContent(format: 'raw')
        else
          contentDirty = false
        titleDirty or urlDirty or contentDirty
      savePage: ->
        data =
          title: $scope.title
          url: $scope.url
          content: $scope.contentEditor.getContent()
        data.page_id = $scope.pageId if $scope.pageId != -1
        $http.post('/api/pages', data).success(saveDone).error(saveError)
      publishPage: ->
        $http.put("/api/pages/#{$scope.versionId}")
          .success(publishDone).error(publishError)

    saveDone = (data, status, headers, config) ->
      $scope.versionId = data.version_id
      $scope.pageId = data.page_id
      $location.url("/#{$scope.pageId}/edit")
      $scope.pageForm.$setPristine()
      $scope.contentEditor.startContent = $scope.contentEditor.getContent(format: 'raw')
      $scope.published = false

    saveError = (data, status, headers, config) ->
      alert("error")

    publishDone = (data, status, headers, config) ->
      $scope.published = true

    publishError = (data, status, headers, config) ->
      alert("error")
  ])

