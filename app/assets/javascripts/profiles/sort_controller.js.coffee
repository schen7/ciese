angular
  .module('ProfilesApp')
  .controller 'ProfilesSortCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.usedFields = []

    $scope.availableGeneralFields = ->
      (f for f in $scope.generalFields when f not in $scope.usedFields)

    $scope.availableWorkFields = ->
      (f for f in $scope.workFields when f not in $scope.usedFields)

    $scope.availableHomeFields = ->
      (f for f in $scope.homeFields when f not in $scope.usedFields)

    $scope.availableNotesFields = ->
      (f for f in $scope.notesFields when f not in $scope.usedFields)

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
      $scope.usedFields = (sortItem.field for sortItem in $scope.sortData.data)
    , true

  ]
