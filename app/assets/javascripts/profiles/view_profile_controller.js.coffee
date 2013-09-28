angular
  .module('ProfilesApp')
  .controller 'ViewProfileCtrl', ['$scope', '$location', '$routeParams', 'Profile', ($scope, $location, $routeParams, Profile) ->

    $scope.profileLoaded = false

    $scope.loadProfile = ->
      $scope.profile = Profile.get
        id: $routeParams.id
      , ->
        $scope.profileLoaded = true
      , ->
        $location.path("/admin/profiles")

    $scope.loadProfile()

  ]

