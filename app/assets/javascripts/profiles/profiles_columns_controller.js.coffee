angular
  .module('ProfilesApp')
  .controller 'ProfilesColumnsCtrl', ['$scope', '$location', ($scope, $location) ->

    $scope.addColumn = ->
      $scope.columns.push(@field)

    $scope.availableColumns = ->
      (field for field in $scope.profileFields when field not in $scope.columns)

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
