Url = require('url')

Promise = require('bluebird')
validator = require('validator')

config = require('../config')

defaultID = (id) ->
  if validator.isURL(id)
    return id
  else
    urlPrefix = Url.format(config)
    return urlPrefix + '/' + id

module.exports = defaultID