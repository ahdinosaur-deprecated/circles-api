Promise = require "bluebird"
jsonld = require('jsonld')

expand = Promise.promisify jsonld.expand
pair = require('./pair')
addDefaultPrefix = require('./addDefaultPrefix')
addContext = require('./addContext')
extractPredicateAndObject = require('./extractPredicateAndObject')

expandSimpleQuery = (query, context, callback) ->
  pair(query)
    .then((terms) -> addDefaultPrefix(terms, context))
    .map((term) -> addContext(term, context))
    .map((doc) -> expand(doc))
    .then(extractPredicateAndObject)
    .then((expanded) -> 
      return {
        subject: db.v('id')
        predicate: expanded.predicate
        object: expanded.object
      })
    .nodeify(callback)

module.exports = expandSimpleQuery