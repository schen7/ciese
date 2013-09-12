angular
  .module('ProfilesApp')
  .controller 'ProfilesFiltersCtrl', ['$scope', '$location', ($scope, $location) ->
    
    $scope.applyFilters = ->
      $scope.profileData.loaded = false
      $location.path '/profiles'

    $scope.addFilter = ->
      $scope.filterData.data.push
        kind: 'Keep only'
        on: 'all'
        conditions: [
          field: 'last_name'
          comparison: 'starts with'
          value: ''
        ]

    $scope.removeFilter = ->
      $scope.filterData.data.splice(@$index, 1)

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

    $scope.$watch 'filterData.data', (newVal, oldVal) ->
      $scope.filterData.dirty = true if newVal isnt oldVal
    , true

  ]
