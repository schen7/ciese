angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', '$location', 'Profile', ($scope, $location, Profile) ->

    $scope.profileData.loaded = false
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
      $location.path("/admin/profiles/#{@profile.id}")

    $scope.quickSort = (newField) ->
      if $scope.sortData.data.length > 0
        {field, order} = $scope.sortData.data[0]
        if newField is field
          order = if order is 'ascending' then 'descending' else 'ascending'
        else
          order = 'ascending'
      $scope.sortData.data = [{field: newField, order: order ? 'ascending'}]
      $scope.filterRecords()

    $scope.$watch 'page', $scope.filterRecords

  ]
