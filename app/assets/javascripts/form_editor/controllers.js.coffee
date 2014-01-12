angular
  .module('FormEditorApp')
  .controller('FormEditorCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->

    angular.extend $scope,
      isDirty: ->
        nameDirty = $scope.formEditor.name.$dirty
        nameDirty
      addField: (kind) ->
        field =
          kind: kind
          required: true
          details: {}
        $scope.form.fields.push(field)
      moveUp: ->
        field = $scope.form.fields.splice(@$index, 1)[0]
        $scope.form.fields.splice(@$index - 1, 0, field)
      moveDown: ->
        field = $scope.form.fields.splice(@$index, 1)[0]
        $scope.form.fields.splice(@$index + 1, 0, field)
      removeField: ->
        $scope.form.fields.splice(@$index, 1)

    $scope.addField("info-field")

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
  .controller('InfoFieldCtrl', ['$scope', '$sce', ($scope, $sce) ->

    $scope.previewInfo = ->
      text = $scope.field.details.text
      if text?
        text = text.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;")
      else
        text = """<span class="empty">Please enter some text.</span>"""
      $sce.trustAsHtml(text)

  ])
  .controller('ShortAnswerFieldCtrl', ['$scope', '$sce', ($scope, $sce) ->

    $scope.previewQuestion = ->
      text = $scope.field.details.question
      if text?
        text = text.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;")
      else
        text = """<span class="empty">Please enter some question text.</span>"""
      $sce.trustAsHtml(text)

  ])



