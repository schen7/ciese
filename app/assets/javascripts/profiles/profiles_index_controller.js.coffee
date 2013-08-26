angular
  .module('ProfilesApp')
  .controller 'ProfilesIndexCtrl', ['$scope', 'ProfilesAppGlobals', 'Profile', ($scope, ProfilesAppGlobals, Profile) ->

    $scope.authenticityToken = ProfilesAppGlobals.authenticityToken
    $scope.profileFields = ProfilesAppGlobals.profileFields
    $scope.profileFields.push('start date')

    stringComparisonOptions = ['starts with', 'ends with', 'contains', 'is']
    dateComparisonOptions = ['is after', 'is before', 'is']

    $scope.dataLoaded = false
    $scope.profiles = Profile.query ->
      $scope.dataLoaded = true

    $scope.filters = []
    $scope.ordering = ['last_name']
    $scope.showing = ['last_name', 'first_name', 'middle_name', 'email1', 'phone1']
    $scope.dirty = false

    $scope.filterRecords = ->
      $scope.dirty = false
      $scope.dataLoaded = false
      $scope.profiles = Profile.query {filters: angular.toJson($scope.filters)}, ->
        $scope.dataLoaded = true

    $scope.addFilter = ->
      $scope.filters.push
        kind: 'Keep only'
        on: 'all'
        conditions: [
          field: 'last_name'
          comparison: 'starts with'
          value: ''
        ]

    $scope.removeFilter = ->
      $scope.filters.splice(@$index, 1)

    $scope.addCondition = ->
      @filter.conditions.push
        field: 'last_name'
        comparison: 'starts with'
        value: ''

    $scope.removeCondition = ->
      @filter.conditions.splice(@$index, 1)

    $scope.addShowing = ->
      $scope.showing.push($scope.newShowField) if $scope.newShowField

    $scope.availableShowFields = ->
      (field for field in $scope.profileFields when field not in $scope.showing)

    $scope.removeShowing = ->
      $scope.showing.splice(@$index, 1)

    $scope.toggleFilterKind = ->
      @filter.kind = if @filter.kind is 'Keep only' then 'Leave out' else 'Keep only'

    $scope.toggleFilterOn = ->
      @filter.on = if @filter.on is 'all' then 'any' else 'all'

    $scope.getComparisonOptions = ->
      if @condition.field.indexOf('date') isnt -1
        options = dateComparisonOptions
      else
        options = stringComparisonOptions
      @condition.comparison = options[0] if @condition.comparison not in options
      options

    $scope.$watch 'filters', (newVal, oldVal) ->
      $scope.dirty = true if newVal isnt oldVal
    , true

  ]
