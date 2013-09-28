angular
  .module('ProfilesApp')
  .controller 'ProfilesAppCtrl', ['$scope', '$location', 'Profile', 'Program', ($scope, $location, Profile, Program) ->

      $scope.generalFields = [
        'ciese_id', 'last_name', 'first_name', 'middle_name', 'prefix', 'title',
        'greeting', 'ssn', 'email1', 'email2', 'department', 'subject', 'grade',
        'function'
      ]

      $scope.notesFields = ['memo1', 'memo2', 'memo3']

      $scope.workFields = [
        'district', 'affiliation', 'address_line_1', 'address_line_2', 'city',
        'state', 'zip', 'country', 'phone1', 'phone2', 'fax'
      ]

      $scope.homeFields = [
        'home_address_line_1', 'home_address_line_2', 'home_city', 'home_state',
        'home_zip', 'home_phone', 'home_mobile', 'home_fax'
      ]

      $scope.sortFields = $scope.generalFields.concat(
        $scope.workFields, $scope.homeFields, $scope.notesFields
      )

      $scope.filterFields = $scope.sortFields.concat([
        'program', 'detail', 'start_date', 'end_date'
      ])

      $scope.columnFields = $scope.sortFields.concat(['activities'])

      $scope.stringComparisonOptions = ["starts with", "ends with", "contains", "is"]

      $scope.dateComparisonOptions = ["is after", "is before", "is"]

      $scope.columns = ['last_name', 'first_name', 'affiliation', 'email1', 'phone1']

      $scope.profileData = {loaded: false, data: []}

      $scope.filterData = {dirty: false, data: []}

      $scope.sortData = {dirty: false, data: [
        {field: 'last_name', order: 'ascending'},
        {field: 'first_name', order: 'ascending'},
      ]}

      $scope.programData = {loaded: false, data: []}

      $scope.options = [
        {name: 'Filter', path: '/admin/profiles/filter'},
        {name: 'Sort', path: '/admin/profiles/sort'},
        {name: 'Columns', path: '/admin/profiles/columns'},
        {name: 'Programs', path: '/admin/profiles/programs'}
      ]

      $scope.isHighlighted = ->
        @option.path is $location.path()

      $scope.getPath = ->
        if @isHighlighted() then '/admin/profiles' else @option.path

  ]
