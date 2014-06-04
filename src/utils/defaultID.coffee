Promise = require('bluebird')
validator = require('validator')

defaultID = (id, context, callback) ->
  if validator.isURL(id)
    callback(null, id)
  else
    idPrefix = "http://open.app/circles/"
    callback(null, idPrefix + id)

module.exports = Promise.promisify(defaultID)