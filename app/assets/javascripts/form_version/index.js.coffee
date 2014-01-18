//= require angular/angular.min
//= require angular/angular-sanitize.min
//= require_self
//= require_directory .

try
  angular.module('FormVersionApp')
catch error
  angular
    .module('FormVersionApp', ['ngSanitize'])
    .config(['$locationProvider', ($locationProvider) ->
      $locationProvider.html5Mode(true)
    ])

angular.element(document).ready ->
  angular.bootstrap(angular.element('body'), ['FormVersionApp'])

