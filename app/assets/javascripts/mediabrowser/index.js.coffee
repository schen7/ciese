//= require angular/angular-cookies.min
//= require_self
//= require_directory .

try
    angular.module('MediaBrowserApp')
catch error
    angular
        .module('MediaBrowserApp', ['ngRoute', 'ngResource', 'ngCookies'])
        .config(['$locationProvider', ($locationProvider) -> $locationProvider.html5Mode(true)])

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#mediabrowser-app').first().get(0), ['MediaBrowserApp'])
