angular
  .module('ProfilesApp')
  .controller 'ProfilesProgramsCtrl', ['$scope', 'Program', ($scope, Program) ->

    $scope.programEditor = {editing: false, program: null, originalProgram: null}

    if not $scope.programData.loaded
      $scope.programData.data = Program.query ->
        $scope.programData.loaded = true

    $scope.editProgram = ->
      $scope.programEditor.editing = true
      $scope.programEditor.originalProgram = @program
      $scope.programEditor.program =
        name: @program.name
        details: ({name: detail} for detail in @program.details)

    $scope.saveProgram = (updateActivites = false) ->
      {originalProgram, program} = $scope.programEditor
      originalProgram.name = program.name
      originalProgram.details = (detail.name for detail in program.details)
      $scope.doneEditing()

    $scope.doneEditing = ->
      $scope.programEditor.editing = false
      $scope.programEditor.program = null
      $scope.programEditor.originalProgram = null

    $scope.addDetail = ->
      $scope.programEditor.program.details.push name: ''

    $scope.removeDetail = ->
      $scope.programEditor.program.details.splice(@$index, 1)

  ]
    
