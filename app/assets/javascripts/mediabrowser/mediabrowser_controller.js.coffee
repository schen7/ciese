angular
  .module('MediaBrowserApp')
  .controller 'MediaBrowserCtrl', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->

    $scope.ready = false
    $scope.path = $routeParams.mediapath ? ''
    subpaths = $scope.path.split('/')
    $scope.breadcrumbs = for name, i in subpaths
      url: "/admin/mediabrowser/#{subpaths[0..i].join('/')}"
      name: name

    getFiles = () ->
      $scope.ready = false
      $http.get('/api/mediabrowser.json', params: path: $scope.path).success (data, status) ->
        $scope.files = data.files
        $scope.ready = true

    $scope.formatSize = (size) ->
      sizeInt = parseInt(size)
      prefixes = ['GB', 'MB', 'KB', 'B']
      n = prefixes.length
      formatted_size = while n -= 1
        if sizeInt < 1024
          break
        sizeInt /= 1024
      "#{Math.round(sizeInt)} #{prefixes[n]}"

    $scope.isImage = (name) ->
      Boolean(name.match(/[.](png|jpg|jpeg|gif)$/))

    $scope.setPath = (root, p1, p2) -> "#{root}/#{p1}/#{p2}".replace(/[/]+/g, '/')

    getFiles()

  ]
