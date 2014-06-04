Promise = require "bluebird"
jsonld = require('jsonld')

expand = Promise.promisify jsonld.expand
addDefaultPrefix = require('./addDefaultPrefix')
addContext = require('./addContext')
getKey = require('./getKey')

expandGroupID = (id, context, callback) ->
  terms = ["group", id]
  addDefaultPrefix(terms, context)
    .then((terms) -> addContext(terms[1], context))
    .then(expand)
    .then((expanded) -> getKey(expanded[0]))
    .nodeify(callback)

module.exports = expandGroupID