angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', '$location', 'Profile', ($scope, $location, Profile) ->

    $scope.filterRecords = ->
      $scope.filterData.dirty = false
      $scope.profileData.data = Profile.query {filters: angular.toJson($scope.filterData.data)}, ->
        $scope.profileData.loaded = true

    $scope.filterRecords() if not $scope.profileData.loaded
  ]
