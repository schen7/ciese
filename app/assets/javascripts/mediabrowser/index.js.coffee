//= require_self
//= require_directory .

try
    angular.module('MediaBrowserApp')
catch error
    angular
        .module('MediaBrowserApp', ['ngRoute', 'ngResource'])

        .config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
            $routeProvider
                .when '/admin/mediabrowser/:mediapath*',
                    templateUrl: 'mediabrowser_index.html'
                    controller: 'MediaBrowserCtrl'
                .when '/admin/mediabrowser',
                    templateUrl: 'mediabrowser_index.html'
                    controller: 'MediaBrowserCtrl'

            $locationProvider.html5Mode(true)
        ])

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#mediabrowser-app').first().get(0), ['MediaBrowserApp'])
