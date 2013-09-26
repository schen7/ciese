//= require_self
//= require_directory .

try
    angular.module('Common')
catch error
    angular
        .module('Common', [])

        .directive 'pagination', ->
          restrict: 'A'
          templateUrl: 'pagination.html'
          replace: true
          scope:
            pages: '='
            page: '='
          link: (scope, el, attr) ->

            scope.newPage = scope.page
            input = el.find('input[type=text]')

            setPage = (page) ->
              page = 1 if page < 1 or isNaN(parseInt(page))
              page = scope.pages if page > scope.pages
              scope.page = scope.newPage = page

            scope.previousPage = -> setPage(scope.page - 1)

            scope.nextPage = -> setPage(scope.page + 1)

            scope.firstPage = -> setPage(1)

            scope.lastPage = -> setPage(scope.pages)

            setNewPage = ->
              scope.$apply -> setPage(scope.newPage)

            input.bind 'blur', setNewPage

            input.bind 'keydown', (evt) ->
              switch evt.which
                when 13 then setNewPage() #enter
                when 38 then scope.$apply ->
                  scope.newPage++ if scope.newPage < scope.pages
                when 40 then scope.$apply ->
                  scope.newPage-- if scope.newPage > 1

        .directive 'stopEvent', ->
          restrict: 'A'
          link: (scope, el, attr) ->
            $(el).on attr.stopEvent, (evt) -> evt.stopPropagation()

