angular
  .module('ProfilesApp')
  .controller 'ProfilesSortCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.applySort = ->
      $scope.sortData.dirty = false

    $scope.$watch 'sortData.data', (newVal, oldVal) ->
      $scope.filterData.dirty = true if newVal isnt oldVal
    , true

  ]
