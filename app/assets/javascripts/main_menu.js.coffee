try
    angular.module('MainMenuApp')
catch error
    angular
        .module('MainMenuApp', ['ngResource'])
        .controller('MainMenuCtrl', ['$scope', ($scope) ->

          $scope.activeMenuItem = ''

          $scope.toggleMenuItem = (item) ->
            $scope.activeMenuItem = if $scope.activeMenuItem is item then '' else item
        ])

    $(document).on 'ready page:load', ->
        angular.bootstrap($('#main_menu').first().get(0), ['MainMenuApp'])

