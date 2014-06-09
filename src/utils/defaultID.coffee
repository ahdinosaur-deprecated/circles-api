Url = require('url')

validator = require('validator')

defaultID = (urlObj, id) ->
  if validator.isURL(id)
    return id
  else
    urlPrefix = Url.format(urlObj)
    return urlPrefix + '/' + id

module.exports = defaultID