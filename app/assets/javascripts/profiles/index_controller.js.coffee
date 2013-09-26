angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', '$location', 'Profile', ($scope, $location, Profile) ->

    $scope.pages = null
    $scope.page = 1

    $scope.filterRecords = ->
      $scope.filterData.dirty = false
      $scope.sortData.dirty = false
      data = Profile.search
        page: $scope.page
        filters: angular.toJson($scope.filterData.data)
        sort: angular.toJson($scope.sortData.data)
      , ->
        $scope.profileData.data = data.profiles
        $scope.pages = data.pages
        $scope.profileData.loaded = true

    $scope.viewProfile = ->
      $location.path("/profiles/#{@profile.id}")

    $scope.filterRecords() if not $scope.profileData.loaded

    $scope.$watch 'page', $scope.filterRecords


  ]
