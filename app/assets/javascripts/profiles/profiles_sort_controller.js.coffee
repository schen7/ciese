angular
  .module('ProfilesApp')
  .controller 'ProfilesSortCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.applySort = ->
      $scope.profileData.loaded = false
      $location.path '/profiles'

    $scope.availableFields = ->
      usedFields = (sortItem.field for sortItem in $scope.sortData.data)
      (field for field in $scope.sortFields when field not in usedFields)

    $scope.addSortItem = ->
      $scope.sortData.data.push({field: @field, order: 'ascending'})

    $scope.toggleOrder = ->
      @sortItem.order = if @sortItem.order is 'ascending' then 'descending' else 'ascending'

    $scope.removeSortItem = ->
      $scope.sortData.data.splice(@$index, 1)

    $scope.sortItemUp = ->
      if not @$first
        $scope.sortData.data.splice(@$index, 1)
        $scope.sortData.data.splice(@$index - 1, 0, @sortItem)

    $scope.sortItemDown = ->
      if not @$last
        $scope.sortData.data.splice(@$index, 1)
        $scope.sortData.data.splice(@$index + 1, 0, @sortItem)

    $scope.$watch 'sortData.data', (newVal, oldVal) ->
      $scope.sortData.dirty = true if newVal isnt oldVal
    , true

  ]
