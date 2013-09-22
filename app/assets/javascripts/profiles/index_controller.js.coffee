angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', '$location', 'Profile', ($scope, $location, Profile) ->

    $scope.filterRecords = ->
      $scope.filterData.dirty = false
      $scope.sortData.dirty = false
      $scope.profileData.data = Profile.query
        filters: angular.toJson($scope.filterData.data)
        sort: angular.toJson($scope.sortData.data)
      , ->
        $scope.profileData.loaded = true

    $scope.viewProfile = ->
      $location.path("/profiles/#{@profile.id}")

    $scope.filterRecords() if not $scope.profileData.loaded

  ]
