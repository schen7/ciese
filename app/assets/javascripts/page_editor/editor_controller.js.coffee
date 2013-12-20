angular
  .module('PageEditorApp')
  .controller('PageEditorCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
    angular.extend $scope,
      isDirty: ->
        urlDirty = $scope.urlForm.url.$dirty
        editor = $scope.contentEditor
        if editor.initialized
          contentDirty = editor.startContent isnt editor.getContent(format: 'raw')
        else
          contentDirty = false
        urlDirty || contentDirty
      savePage: ->
        data =
          url: $scope.url
          content: $scope.contentEditor.getContent()
        data.page_id = $scope.pageId if $scope.pageId != -1
        $http.post('/admin/pages', data).success(saveDone).error(saveError)
      publishPage: ->
        data =
          version_id: $scope.versionId
          page_id: $scope.pageId
        $http.post("/admin/pages/publish/editor", data)
          .success(publishDone).error(publishError)

    saveDone = (data, status, headers, config) ->
      $scope.versionId = data.version_id
      $scope.pageId = data.page_id
      $location.url("/admin/pages/edit/#{$scope.pageId}")
      $scope.urlForm.$setPristine()
      $scope.contentEditor.startContent = $scope.contentEditor.getContent(format: 'raw')
      $scope.published = false

    saveError = (data, status, headers, config) ->
      alert("error")

    publishDone = (data, status, headers, config) ->
      $scope.published = true

    publishError = (data, status, headers, config) ->
      alert("error")
  ])

