angular
  .module('ProfilesApp')
  .controller 'ProfilesProgramsCtrl', ['$scope', 'Program', ($scope, Program) ->

    $scope.programEditor = {editing: false, program: null, originalProgram: null}

    $scope.loadPrograms = ->
      $scope.programData.data = Program.query ->
        $scope.programData.loaded = true

    $scope.editProgram = ->
      program = @program ? new Program(name: '', details: [''])
      $scope.programEditor.editing = true
      $scope.programEditor.originalProgram = program
      $scope.programEditor.program =
        name: program.name
        details: ({name: detail, removed: 'no'} for detail in program.details)

    $scope.saveProgram = (updateActivities = false) ->
      {originalProgram, program} = $scope.programEditor
      originalProgram.name = program.name
      originalProgram.details = (detail.name for detail in program.details)
      if originalProgram.id?
        originalProgram.$update({update_activities: updateActivities})
        $scope.profileData.loaded = false
      else
        originalProgram.$save ->
          $scope.programData.data.push(originalProgram)
      $scope.doneEditing()

    $scope.doneEditing = ->
      $scope.programEditor.editing = false
      $scope.programEditor.program = null
      $scope.programEditor.originalProgram = null

    $scope.addDetail = ->
      $scope.programEditor.program.details.push(name: '', removed: 'no')

    $scope.removeDetail = ->
      @detail.name = ''
      @detail.removed = 'yes'

    $scope.deleteProgram = (updateActivities = false) ->
      console.log $scope.programEditor.originalProgram
      $scope.programEditor.originalProgram.$delete ->
        $scope.doneEditing()
        $scope.profileData.loaded = false
        $scope.programData.loaded = false
        $scope.loadPrograms()

    $scope.loadPrograms() if not $scope.programData.loaded

  ]
    
