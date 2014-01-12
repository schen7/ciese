//= require angular/angular.min
//= require common
//= require_self
//= require_directory .

angular
  .module('FormEditorApp', ['Common'])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode(true)
  ])

angular.element(document).ready ->
  angular.bootstrap(angular.element('#form-editor'), ['FormEditorApp'])

