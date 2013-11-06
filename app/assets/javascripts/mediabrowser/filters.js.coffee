angular
  .module('MediaBrowserApp')
  .filter 'formatSize', ->
    (size) ->
      sizeInt = parseInt(size)
      prefixes = ['GB', 'MB', 'KB', 'B']
      n = prefixes.length
      formatted_size = while n -= 1
        if sizeInt < 1024
          break
        sizeInt /= 1024
      "#{Math.round(sizeInt)} #{prefixes[n]}"


