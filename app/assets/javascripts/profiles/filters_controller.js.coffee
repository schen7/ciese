angular
  .module('ProfilesApp')
  .controller 'ProfilesFiltersCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.newFilters = angular.copy($scope.filterData.data)
    $scope.dirty = false

    defaultFilter =
      kind: 'Keep only'
      on: 'all'
      conditions: [
        field: 'last_name'
        comparison: 'starts with'
        value: ''
      ]

    $scope.applyFilters = ->
      $scope.filterData.data = if filtersBlank() then [] else $scope.newFilters
      $location.path '/admin/profiles'

    filtersBlank = ->
      angular.equals($scope.newFilters[0], defaultFilter)

    $scope.addFilter = ->
      $scope.newFilters.push(angular.copy(defaultFilter))

    $scope.removeFilter = ->
      $scope.newFilters.splice(@$index, 1)
      $scope.checkFilters()

    $scope.checkFilters = ->
      $scope.addFilter() if $scope.newFilters.length == 0

    $scope.addCondition = ->
      @filter.conditions.push
        field: 'last_name'
        comparison: 'starts with'
        value: ''

    $scope.removeCondition = ->
      @filter.conditions.splice(@$index, 1)

    $scope.toggleFilterKind = ->
      @filter.kind = if @filter.kind is 'Keep only' then 'Leave out' else 'Keep only'

    $scope.toggleFilterOn = ->
      @filter.on = if @filter.on is 'all' then 'any' else 'all'

    $scope.getComparisonOptions = ->
      if @condition.field.indexOf('date') isnt -1
        options = $scope.dateComparisonOptions
      else
        options = $scope.stringComparisonOptions
      @condition.comparison = options[0] if @condition.comparison not in options
      options

    $scope.checkFilters()

    $scope.$watch 'newFilters', (newVal, oldVal) ->
      $scope.dirty = true if newVal isnt oldVal
    , true

  ]
