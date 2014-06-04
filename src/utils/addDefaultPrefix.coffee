Promise = require "bluebird"
validator = require "validator"

addDefaultPrefix = (terms, context, callback) ->
  if validator.isURL terms[1]
    callback null, terms
  else if terms[1].indexOf(':') is -1
    prefix = context[terms[0]]["defaultPrefix"]
    terms[1] = prefix + ":" + terms[1]
    callback null, terms
  else
    callback null, terms

module.exports = Promise.promisify addDefaultPrefix