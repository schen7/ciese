titleize = (input) ->
  input ?= ''
  input.replace(/_/g, ' ').replace /\w*/g, (txt) ->
    txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

camelize = (input) ->
  titleize(input).replace(/\s/g, '')

angular
  .module('ProfilesApp')
  .filter('titleize', -> titleize)
  .filter('camelize', -> camelize)
