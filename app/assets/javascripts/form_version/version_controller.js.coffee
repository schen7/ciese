angular
  .module('FormVersionApp')
  .controller('FormVersionCtrl', ['$scope', '$rootScope', '$location', '$http', '$document', '$sce', ($scope, $rootScope, $location, $http, $document, $sce) ->

    angular.extend $rootScope,
      versionReady: true
      prevVersion: ->
        i = $scope.form_versions.indexOf($scope.form.form_version_id) - 1
        if i >= 0 then $scope.form_versions[i] else null
      nextVersion: ->
        i = $scope.form_versions.indexOf($scope.form.form_version_id) + 1
        if i < $scope.form_versions.length then $scope.form_versions[i] else null
      isPrevVersion: -> $scope.prevVersion() isnt null
      isNextVersion: -> $scope.nextVersion() isnt null
      getPrevVersion: ->
        prevVersion = $scope.prevVersion()
        $http.get("/api/forms/#{prevVersion}").success(updateVersion) if prevVersion?
      getNextVersion: ->
        nextVersion = $scope.nextVersion()
        $http.get("/api/forms/#{nextVersion}").success(updateVersion) if nextVersion?
      publishForm: ->
        data = {form_version_id: $scope.form.form_version_id, form_id: $scope.form.form_id}
        $http.put("/api/forms/#{$scope.form.form_version_id}", data)
          .success(publishDone).error(publishError)
      unpublishForm: ->
        data = {form_version_id: $scope.form.form_version_id, form_id: $scope.form.form_id}
        $http.delete("/api/forms/#{$scope.form.form_version_id}", data)
          .success(publishDone).error(publishError)
      renderHtml: (text) ->
        if text?
          text = text.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;")
        $sce.trustAsHtml(text)

    decodeDetails = (form) ->
      field.details = angular.fromJson(field.details) for field in form.fields

    encodeDetails = (form) ->
      field.details = angular.toJson(field.details) for field in form.fields

    $document.on 'keydown', (evt) ->
      $scope.getPrevVersion() if evt.which is 37
      $scope.getNextVersion() if evt.which is 39
    
    updateVersion = (data, status, headers, config) ->
      $rootScope.form = data.form_version
      decodeDetails($scope.form)
      $rootScope.form_versions = data.meta.form_versions
      $location.path("/admin/forms/#{$scope.form.form_id}/versions/#{$scope.form.form_version_id}")

    publishDone = (data, status, headers, config) ->
      $scope.form.published = data.published
      publisheError(data, status, headers, config) if data.errors

    publishError = (data, status, headers, config) ->
      alert("error")

    decodeDetails($scope.form)

  ])

