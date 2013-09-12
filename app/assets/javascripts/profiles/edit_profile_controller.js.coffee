angular
  .module('ProfilesApp')
  .controller 'EditProfileCtrl', ['$scope', '$location', '$routeParams', 'Profile', 'Program', ($scope, $location, $routeParams, Profile, Program) ->

    $scope.profileLoaded = false

    $scope.loadProfile = ->
      $scope.profile = Profile.get
        id: $routeParams.id
      , ->
        $scope.profileLoaded = true
      , ->
        $location.path("/profiles")

    $scope.loadPrograms = ->
      $scope.programData.data = Program.query ->
        $scope.programData.loaded = true

    $scope.getDetails = ->
      program = (program for program in $scope.programData.data when program.name is @activity.program)[0]
      program.details

    $scope.loadProfile()
    $scope.loadPrograms()

  ]


