angular
  .module('ProfilesApp')
  .controller('EditProfileCtrl', ['$scope', '$location', '$filter', '$routeParams', 'Profile', 'Program', ($scope, $location, $filter, $routeParams, Profile, Program) ->

    $scope.profileLoaded = false

    loadProfile = ->
      $scope.profile = Profile.get
        id: $routeParams.id
      , ->
        for activity in $scope.profile.activities
          activity.start_date = $filter('dateFix')(activity.start_date, 'mediumDate')
          activity.end_date = $filter('dateFix')(activity.end_date, 'mediumDate')
        $scope.profileLoaded = true
      , ->
        $location.path("/admin/profiles")

    loadPrograms = ->
      $scope.programData.data = Program.query ->
        $scope.programData.loaded = true

    $scope.saveProfile = ->
      $scope.profile.$update ->
        $location.path("/admin/profiles/#{$scope.profile.id}")

    $scope.getActivities = ->
      $filter('filter')($scope.profile.activities, {_destroy: '!1'})

    $scope.removeActivity = ->
      @activity._destroy = '1'

    $scope.addActivity = ->
      $scope.profile.activities.push
        program: ''
        detail: ''
        start_date: ''
        end_date: ''

    loadProfile()
    loadPrograms()

  ])
  .controller('EditActivityCtrl', ['$scope', '$filter', ($scope, $filter) ->

    programName = $scope.activity.program
    detailName = $scope.activity.detail

    $scope.getProgramNames = ->
      programNames = (program.name for program in $scope.programData.data)
      if programName not in programNames
        programNames.splice(0, 0, programName)
      programNames

    isSelectedProgram = (program) ->
      program.name is $scope.activity.program

    $scope.getDetailNames = ->
      program = $filter('filter')($scope.programData.data, isSelectedProgram)[0]
      detailNames = angular.copy(program?.details ? [])
      if $scope.activity.program is programName
        if detailName and detailName not in detailNames
          detailNames.splice(0, 0, detailName)
      $scope.activity.detail = '' unless $scope.activity.detail in detailNames
      detailNames

  ])


