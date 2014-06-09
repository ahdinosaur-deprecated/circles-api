Promise = require "bluebird"

expandShorthand = (prefix, id, context, callback) ->
  if context[prefix]?
    iri = context[prefix] + id
    callback null, iri
  else
    error = new Error ""
    callback error

module.exports = Promise.promisify expandShorthand