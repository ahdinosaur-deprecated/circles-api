Promise = require "bluebird"

expandShorthand = (shorthand, context, callback) ->
  prefix = shorthand.split(':')[0]
  id = shorthand.split(':')[1]
  if context[prefix]?
    iri = context[prefix] + id
    callback null, iri
  else
    error = new Error ""
    callback error

module.exports = Promise.promisify expandShorthand