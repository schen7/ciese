angular
  .module('PageVersionApp')
  .controller('PageVersionCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
    angular.extend $scope,
      prevVersion: ->
        i = $scope.versions.indexOf($scope.page.id) - 1
        if i >= 0 then $scope.versions[i] else null
      nextVersion: ->
        i = $scope.versions.indexOf($scope.page.id) + 1
        if i < $scope.versions.length then $scope.versions[i] else null
      isPrevVersion: -> $scope.prevVersion() isnt null
      isNextVersion: -> $scope.nextVersion() isnt null
      getPrevVersion: ->
        $http.get("/api/pages/#{$scope.prevVersion()}").success(updateVersion)
      getNextVersion: ->
        $http.get("/api/pages/#{$scope.nextVersion()}").success(updateVersion)
      publishPage: ->
        data = {version_id: $scope.page.id, page_id: $scope.page.page_id}
        $http.put("/api/pages/#{$scope.page.id}", data)
          .success(publishDone).error(publishError)
      unpublishPage: ->
        data = {version_id: $scope.page.id, page_id: $scope.page.page_id}
        $http.delete("/api/pages/#{$scope.page.id}", data)
          .success(publishDone).error(publishError)
    
    updateVersion = (data, status, headers, config) ->
      $scope.page = data.page
      $scope.versions = data.meta.versions
      $location.path("/admin/pages/#{$scope.page.page_id}/versions/#{$scope.page.id}")

    publishDone = (data, status, headers, config) ->
      $scope.page.published = data.published
      publisheError(data, status, headers, config) if data.errors

    publishError = (data, status, headers, config) ->
      alert("error")

  ])

