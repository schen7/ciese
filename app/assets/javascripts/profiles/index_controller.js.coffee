angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', '$location', 'Profile', ($scope, $location, Profile) ->

    $scope.generalFields = [
      'ciese_id', 'last_name', 'first_name', 'middle_name', 'prefix', 'title',
      'greeting', 'ssn', 'email1', 'email2', 'department', 'subject', 'grade',
      'function'
    ]
    $scope.notesFields = ['memo1', 'memo2', 'memo3']
    $scope.workFields = [
      'district', 'affiliation', 'address_line_1', 'address_line_2', 'city',
      'state', 'zip', 'country', 'phone1', 'phone2', 'fax'
    ]
    $scope.homeFields = [
      'address_line_1', 'address_line_2', 'city', 'state', 'zip', 'phone',
      'mobile', 'fax'
    ]
    $scope.viewingProfile = null

    $scope.filterRecords = ->
      $scope.filterData.dirty = false
      $scope.sortData.dirty = false
      $scope.profileData.data = Profile.query
        filters: angular.toJson($scope.filterData.data)
        sort: angular.toJson($scope.sortData.data)
      , ->
        $scope.profileData.loaded = true

    $scope.viewProfile = ->
      $scope.viewingProfile = @profile

    $scope.doneViewing = ->
      $scope.viewingProfile = null

    $scope.setProfile = ->
      alert 'here'
      @profile = @viewingProfile

    $scope.filterRecords() if not $scope.profileData.loaded
  ]
