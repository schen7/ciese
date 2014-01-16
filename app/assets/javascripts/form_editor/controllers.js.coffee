angular
  .module('FormEditorApp')
  .controller('FormEditorCtrl', ['$scope', '$rootScope', '$location', '$http', '$sce', '$window', ($scope, $rootScope, $location, $http, $sce, $window) ->

    angular.extend $rootScope,
      canSave: ->
        $scope.formBuilder?.$dirty and $scope.formBuilder?.$valid
      canPublish: -> (
        $scope.form.form_version_id? and not $scope.form.published and
        $scope.formBuilder?.$pristine and $scope.formBuilder?.$valid
      )
      saveForm: ->
        data = form: angular.copy($scope.form)
        data.form.fields = for field in data.form.fields
          kind: field.kind
          details: angular.toJson(field.details)
        $http.post('/api/forms', data).success(saveDone).error(saveError)
      publishForm: ->
        $http.put("/api/forms/#{$scope.form.form_version_id}")
          .success(publishDone).error(publishError)

    angular.extend $scope,
      editorReady: true
      selected: null
      select: (index) ->
        $window.event.stopPropagation()
        $scope.selected = index
      getMode: (index) ->
        if $scope.selected is index then 'edit-mode' else 'preview-mode'
      addField: (kind) ->
        $window.event.stopPropagation()
        $scope.form.fields.push
          kind: kind
          details:
            required: true
        $scope.selected = $scope.form.fields.length - 1
      moveUp: ->
        field = $scope.form.fields.splice(@$index, 1)[0]
        $scope.form.fields.splice(@$index - 1, 0, field)
      moveDown: ->
        field = $scope.form.fields.splice(@$index, 1)[0]
        $scope.form.fields.splice(@$index + 1, 0, field)
      removeField: ->
        $scope.form.fields.splice(@$index, 1)
      renderHtml: (text) ->
        if text?
          text = text.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;")
        $sce.trustAsHtml(text)

    saveDone = (data, status, headers, config) ->
      if data.errors?
        saveError(data, status, headers, config)
      else
        $scope.form = data.form_version
        $location.url("/#{$scope.form.form_id}/edit")
        $scope.formBuilder.$setPristine()

    saveError = (data, status, headers, config) ->
      list = (" - #{e}" for e in data.errors).join('\n')
      alert("There were errors saving the form:\n" + list)

    publishDone = (data, status, headers, config) ->
      if data.errors?
        publishError(data, status, headers, config)
      else
        $scope.form = data.form

    publishError = (data, status, headers, config) ->
      list = (" - #{e}" for e in data.errors).join('\n')
      alert("There were errors publishing the form:\n" + list)

    $scope.$watch 'form', (newVal, oldVal) ->
      $scope.formBuilder?.$setDirty() if newVal isnt oldVal
    , true

    # TODO: Remove this - quick population of initial data for manual testing
    $scope.form.fields = [
      {kind: 'info', details: { text: 'Form information' }},
      {kind: 'short-answer', details: { label: 'Name', required: true }},
      {kind: 'short-answer', details: { label: 'School', required: true }},
      {kind: 'long-answer', details: { label: 'School Address', required: true }},
      {kind: 'single-choice', details: {
        question: "Which one?"
        required: true
        choices: [
          {label: 'Choice A' }, {label: 'Choice B' }, {label: 'Choice C' },
          {label: 'Choice D' }, {label: 'Choice E' }, {label: 'Choice F' }
        ]}
      },
      {kind: 'multiple-choice', details: {
        question: "Which one?"
        required: true
        choices: [
          {label: 'Choice A' }, {label: 'Choice B' }, {label: 'Choice C' },
          {label: 'Choice D' }, {label: 'Choice E' }, {label: 'Choice F' }
        ]}
      }
    ]

    angular.element($window.document).on 'click', ->
      $scope.$apply -> $scope.selected = null

    angular.element($window.document).on 'keydown', (evt) ->
      if evt.keyCode is 27
        $scope.$apply -> $scope.selected = null

  ])
  .controller('ChoiceFieldCtrl', ['$scope', ($scope) ->

    $scope.field.details.choices ?= [
      {label: 'A'},
      {label: 'B'},
      {label: 'C'}
    ]

    angular.extend $scope,
      addChoice: ->
        $scope.field.details.choices.push
          label: ""
      removeChoice: ->
        $scope.field.details.choices.splice(@$index, 1)

  ])



