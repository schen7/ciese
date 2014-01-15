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

    angular.extend $scope,
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

    $scope.$watch 'form', (newVal, oldVal) ->
      $scope.formBuilder?.$setDirty() if newVal isnt oldVal
    , true

    # TODO: Remove this - quick population of initial data for manual testing
    $scope.form.fields = [
      {kind: 'info-field', details: { text: 'Form information' }},
      {kind: 'short-answer-field', details: { label: 'Name', required: true }},
      {kind: 'short-answer-field', details: { label: 'School', required: true }},
      {kind: 'long-answer-field', details: { label: 'School Address', required: true }},
      {kind: 'single-choice-field', details: {
        question: "Which one?"
        required: true
        choices: [
          {label: 'Choice A' }, {label: 'Choice B' }, {label: 'Choice C' },
          {label: 'Choice D' }, {label: 'Choice E' }, {label: 'Choice F' }
        ]}
      },
      {kind: 'multiple-choice-field', details: {
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

      # saveForm: ->
      #   data =
      #     title: $scope.title
      #     url: $scope.url
      #     content: $scope.contentEditor.getContent()
      #   data.page_id = $scope.pageId if $scope.pageId != -1
      #   $http.post('/api/pages', data).success(saveDone).error(saveError)
      # publishForm: ->
      #   $http.put("/api/pages/#{$scope.versionId}")
      #     .success(publishDone).error(publishError)

    # saveDone = (data, status, headers, config) ->
    #   $scope.versionId = data.version_id
    #   $scope.pageId = data.page_id
    #   $location.url("/#{$scope.pageId}/edit")
    #   $scope.pageForm.$setPristine()
    #   $scope.contentEditor.startContent = $scope.contentEditor.getContent(format: 'raw')
    #   $scope.published = false

    # saveError = (data, status, headers, config) ->
    #   alert("error")

    # publishDone = (data, status, headers, config) ->
    #   $scope.published = true

    # publishError = (data, status, headers, config) ->
    #   alert("error")
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



