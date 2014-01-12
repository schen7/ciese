# titleize = (input) ->
#   input ?= ''
#   input.replace(/_/g, ' ').replace /\w*/g, (txt) ->
#     txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

# camelize = (input) ->
#   titleize(input).replace(/\s/g, '')

angular
  .module('ProfilesApp')
  # .filter('titleize', -> titleize)
  # .filter('camelize', -> camelize)
  # TODO: Get rid of the dateFix filter once angular is upgraded to > 1.1.2
  .filter('dateFix', ['$filter', ($filter) ->
    (date, format) ->
      if typeof(date) isnt "string"
        $filter('date')(date, format)
      else
        offset = new Date(Date.parse(date)).getTimezoneOffset() / 60
        offsetString = switch
          when Math.abs(offset) > 9 then "#{offset}"
          else "0#{offset}"
        tzString = switch
          when offset > 0 then "-#{offsetString}00"
          when offset < 0 then "+#{offsetString}00"
          else 'Z'
        $filter('date')("#{date}T00:00#{tzString}", format)
  ])

