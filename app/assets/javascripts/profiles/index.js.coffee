//= require angular/angular.min
//= require angular/angular-resource.min
//= require common
//= require_self
//= require_directory .

try
    angular.module('ProfilesApp')
catch error
    angular
        .module('ProfilesApp', ['ngResource', 'Common'])

        .config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
            $routeProvider
                .when '/admin/profiles',
                    templateUrl: 'profiles_index.html'
                    controller: 'ProfilesIndexCtrl'
                .when '/admin/profiles/programs',
                    templateUrl: 'programs.html'
                    controller: 'ProfilesProgramsCtrl'
                .when '/admin/profiles/filter',
                    templateUrl: 'filters.html'
                    controller: 'ProfilesFiltersCtrl'
                .when '/admin/profiles/sort',
                    templateUrl: 'sort.html'
                    controller: 'ProfilesSortCtrl'
                .when '/admin/profiles/columns',
                    templateUrl: 'columns.html'
                    controller: 'ProfilesColumnsCtrl'
                .when '/admin/profiles/new',
                    templateUrl: 'edit_profile.html'
                    controller: 'EditProfileCtrl'
                .when '/admin/profiles/:id',
                    templateUrl: 'view_profile.html'
                    controller: 'ViewProfileCtrl'
                .when '/admin/profiles/:id/edit',
                    templateUrl: 'edit_profile.html'
                    controller: 'EditProfileCtrl'

            $locationProvider.html5Mode(true)
        ])

        .factory('Profile', ['$resource', ($resource) ->
            $resource('/api/profiles/:id', {id: '@id'}, {search: {method: 'GET'}, update: {method: 'PUT'}})
        ])

        .factory('Program', ['$resource', ($resource) ->
            $resource('/api/programs/:id', {id: '@id'}, {update: {method: 'PUT'}})
        ])

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#profiles-app').first().get(0), ['ProfilesApp'])
