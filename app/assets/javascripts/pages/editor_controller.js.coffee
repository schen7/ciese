angular
  .module('PageEditorApp')
  .controller('PageEditorCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
    angular.extend $scope,
      url: $location.path().replace(/^\/admin\/pages\/(?:new|edit)/, '')
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
        $http.post('/admin/pages', data).success(saveDone).error(saveError)
      publishPage: ->
        data =
          id: $scope.pageId
          url: $scope.url
        $http.post("/admin/pages/#{$scope.pageId}", data)
          .success(publishDone).error(publishError)

    saveDone = (data, status, headers, config) ->
      $location.path('/admin/pages/edit' + $scope.url)
      $scope.urlForm.$setPristine()
      $scope.contentEditor.startContent = $scope.contentEditor.getContent(format: 'raw')
      $scope.pageId = data.id
      $scope.published = false

    saveError = (data, status, headers, config) ->
      alert("error")

    publishDone = (data, status, headers, config) ->
      $scope.published = true

    publishError = (data, status, headers, config) ->
      alert("error")
  ])

