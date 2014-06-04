Promise = require "bluebird"

addContext = (term, context, callback) ->
  doc = {}
  doc[term] = term
  doc['context'] = context
  callback(null, doc)

module.exports = Promise.promisify addContext