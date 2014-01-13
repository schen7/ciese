angular
  .module('FormEditorApp')
  .controller('FormEditorCtrl', ['$scope', '$location', '$http', '$sce', '$window', ($scope, $location, $http, $sce, $window) ->

    angular.extend $scope,
      selected: null
      select: ->
        $window.event.stopPropagation()
        $scope.selected = @$index
      getMode: ->
        if $scope.selected is @$index then 'edit-mode' else 'preview-mode'
      isDirty: ->
        nameDirty = $scope.formEditor.name.$dirty
        nameDirty
      addField: (kind) ->
        $window.event.stopPropagation()
        $scope.form.fields.push
          kind: kind
          required: true
          details: {}
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

    $scope.form.fields = [
      {kind: 'info-field', required: true, details: { text: 'Form information' }},
      {kind: 'short-answer-field', required: true, details: { label: 'Name' }},
      {kind: 'short-answer-field', required: true, details: { label: 'School' }},
      {kind: 'long-answer-field', required: true, details: { label: 'School Address' }},
      {kind: 'single-choice-field', required: true, details: {
        question: "Which one?"
        choices: [
          {label: 'Choice A' }, {label: 'Choice B' }, {label: 'Choice C' },
          {label: 'Choice D' }, {label: 'Choice E' }, {label: 'Choice F' }
        ]}
      },
      {kind: 'multiple-choice-field', required: true, details: {
        question: "Which one?"
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



