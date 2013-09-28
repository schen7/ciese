angular
  .module('ProfilesApp')
  .controller 'ProfilesColumnsCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.notesAndActivitiesFields = $scope.notesFields.concat(['activities'])

    $scope.availableGeneralFields = ->
      (f for f in $scope.generalFields when f not in $scope.columns)

    $scope.availableWorkFields = ->
      (f for f in $scope.workFields when f not in $scope.columns)

    $scope.availableHomeFields = ->
      (f for f in $scope.homeFields when f not in $scope.columns)

    $scope.availableNotesAndActivitiesFields = ->
      (f for f in $scope.notesAndActivitiesFields when f not in $scope.columns)

    $scope.addColumn = ->
      $scope.columns.push(@field)

    $scope.availableColumns = ->
      (field for field in $scope.columnFields when field not in $scope.columns)

    $scope.removeColumn = ->
      $scope.columns.splice(@$index, 1)

    $scope.columnUp = ->
      if not @$first
        $scope.columns.splice(@$index, 1)
        $scope.columns.splice(@$index - 1, 0, @field)

    $scope.columnDown = ->
      if not @$last
        $scope.columns.splice(@$index, 1)
        $scope.columns.splice(@$index + 1, 0, @field)

  ]
