angular
  .module('MediaBrowserApp')
  .controller 'MediaBrowserCtrl', ['$scope', '$window', '$location', '$http', ($scope, $window, $location, $http) ->

    rootPath = "/admin/mediabrowser"

    setPath = (newPath, oldPath) ->
      $scope.path = newPath.replace(rootPath, '').replace(/^\/+/, '')
      subpaths = $scope.path.split('/')
      $scope.breadcrumbs = for name, i in subpaths
        mbPath: "#{rootPath}/#{subpaths[0..i].join('/')}"
        name: name
      $http.get('/api/mediabrowser.json', params: path: $scope.path).success (data, status) ->
        for file in data.files
          if file.type is 'directory'
            file.mbPath = "#{rootPath}/#{$scope.path}/#{file.name}".replace(/\/+/g, '/')
        $scope.files = data.files

    $scope.$watch((-> $location.path()), setPath)

    setPath($location.path())

  ]
