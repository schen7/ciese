//= require_self
//= require_directory .

try
    angular.module('ProfilesApp')
catch error
    angular
        .module('ProfilesApp', ['ngResource', 'Common'])

        .config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
            $routeProvider
                .when '/profiles',
                    templateUrl: 'profiles_index.html'
                    controller: 'ProfilesIndexCtrl'
                .when '/profiles/programs',
                    templateUrl: 'programs.html'
                    controller: 'ProfilesProgramsCtrl'
                .when '/profiles/filter',
                    templateUrl: 'filters.html'
                    controller: 'ProfilesFiltersCtrl'
                .when '/profiles/sort',
                    templateUrl: 'sort.html'
                    controller: 'ProfilesSortCtrl'
                .when '/profiles/columns',
                    templateUrl: 'columns.html'
                    controller: 'ProfilesColumnsCtrl'
                .when '/profiles/:id',
                    templateUrl: 'view_profile.html'
                    controller: 'ViewProfileCtrl'
                .when '/profiles/:id/edit',
                    templateUrl: 'edit_profile.html'
                    controller: 'EditProfileCtrl'

            $locationProvider.html5Mode(true)
        ])

        .factory('Profile', ['$resource', ($resource) ->
            $resource('/profiles/:id', {id: '@id'}, {update: {method: 'PUT'}})
        ])

        .factory('Program', ['$resource', ($resource) ->
            $resource('/profiles/programs/:id', {id: '@id'}, {update: {method: 'PUT'}})
        ])

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#profiles-app').first().get(0), ['ProfilesApp'])
