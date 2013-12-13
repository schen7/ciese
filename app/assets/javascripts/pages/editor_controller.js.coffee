angular
  .module('PageEditorApp')
  .controller('PageEditorCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
    angular.extend $scope,
      url: $location.path().replace(/^\/admin\/pages\/(?:new|edit)/, '')
      published: false
      isDirty: ->
        urlDirty = $scope.urlForm.url.$dirty
        editor = $scope.contentEditor
        if editor.initialized
          contentDirty = editor.startContent isnt editor.getContent()
        else
          contentDirty = false
        urlDirty || contentDirty
      savePage: ->
        data =
          url: $scope.url
          content: $scope.contentEditor.getContent()
        $http.post('/admin/pages', data).success(saveDone).error(saveError)

    saveDone = (data, status, headers, config) ->
      $location.path('/admin/pages/edit' + $scope.url)
      $scope.urlForm.$setPristine()
      $scope.contentEditor.startContent = $scope.contentEditor.getContent()

    saveError = (data, status, headers, config) ->
      alert("error")
    
  ])

