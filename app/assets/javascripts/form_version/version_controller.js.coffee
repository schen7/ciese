angular
  .module('FormVersionApp')
  .controller('FormVersionCtrl', ['$scope', '$rootScope', '$location', '$http', '$document', '$sce', ($scope, $rootScope, $location, $http, $document, $sce) ->

    angular.extend $rootScope,
      versionReady: true
      prevVersion: ->
        i = $scope.form_version_ids.indexOf($scope.form_version.id) - 1
        if i >= 0 then $scope.form_version_ids[i] else null
      nextVersion: ->
        i = $scope.form_version_ids.indexOf($scope.form_version.id) + 1
        if i < $scope.form_version_ids.length then $scope.form_version_ids[i] else null
      isPrevVersion: -> $scope.prevVersion() isnt null
      isNextVersion: -> $scope.nextVersion() isnt null
      getPrevVersion: ->
        prevVersion = $scope.prevVersion()
        $http.get("/api/forms/#{prevVersion}").success(updateVersion) if prevVersion?
      getNextVersion: ->
        nextVersion = $scope.nextVersion()
        $http.get("/api/forms/#{nextVersion}").success(updateVersion) if nextVersion?
      publishForm: ->
        data = {form_version_id: $scope.form_version.id, form_id: $scope.form_version.form_id}
        $http.put("/api/forms/#{$scope.form_version.id}", data)
          .success(publishDone).error(publishError)
      unpublishForm: ->
        data = {form_version_id: $scope.form_version.id, form_id: $scope.form_version.form_id}
        $http.delete("/api/forms/#{$scope.form_version.id}", data)
          .success(publishDone).error(publishError)
      renderHtml: (text) ->
        if text?
          text = text.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;")
        $sce.trustAsHtml(text)

    $document.on 'keydown', (evt) ->
      $scope.getPrevVersion() if evt.which is 37
      $scope.getNextVersion() if evt.which is 39
    
    updateVersion = (data, status, headers, config) ->
      $rootScope.form_version = data.form_version
      $rootScope.form_version_ids = data.meta.form_version_ids
      $location.path("/admin/forms/#{$scope.form_version.form_id}/versions/#{$scope.form_version.id}")

    publishDone = (data, status, headers, config) ->
      $scope.form_version.published = data.published
      publisheError(data, status, headers, config) if data.errors

    publishError = (data, status, headers, config) ->
      list = (" - #{e}" for e in data.errors).join('\n')
      alert("There were errors publishing the form:\n" + list)

  ])

