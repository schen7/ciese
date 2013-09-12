//= require_self
//= require_directory .

try
    angular.module('ProfilesApp')
catch error
    angular
        .module('ProfilesApp', ['ngResource'])

        .config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
            $routeProvider
                .when '/profiles',
                    templateUrl: 'profiles_index.html'
                    controller: 'ProfilesIndexCtrl'
                .when '/profiles/filter',
                    templateUrl: 'filters.html'
                    controller: 'ProfilesFiltersCtrl'
                .when '/profiles/sort',
                    templateUrl: 'sort.html'
                    controller: 'ProfilesSortCtrl'
                .when '/profiles/columns',
                    templateUrl: 'columns.html'
                    controller: 'ProfilesColumnsCtrl'
                .when '/profiles/programs',
                    templateUrl: 'programs.html'
                    controller: 'ProfilesProgramsCtrl'

            $locationProvider.html5Mode(true)
        ])

        .factory('Profile', ['$resource', ($resource) ->
            $resource('/profiles/:id', {id: '@id'}, {update: {method: 'PUT'}})
        ])

        .factory('Program', ['$resource', ($resource) ->
            $resource('/profiles/programs/:id', {id: '@id'}, {update: {method: 'PUT'}})
        ])

        .directive 'stopEvent', ->
          restrict: 'A'
          link: (scope, el, attr) ->
            $(el).on attr.stopEvent, (evt) -> evt.stopPropagation()

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#profiles-app').first().get(0), ['ProfilesApp'])
