validator = require "validator"
expandShorthand = require "./expandShorthand"
Promise = require "bluebird"

expand = (term, context, callback) ->
  if validator.isURL term
    callback null, term
  else if term.indexOf(':') > -1
    prefix = term.split(':')[0]
    id = term.split(':')[1]
    expandShorthand(prefix, id, context)
      .nodeify(callback)
  else
    if context[term]?
      iri = context[term]
      callback null, iri
    else
      error = new Error "No matching IRI for " + term
      callback error

module.exports = Promise.promisify expand






