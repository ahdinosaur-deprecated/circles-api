jsonld = require "jsonld"
Promise = require "bluebird"
validator = require "validator"

addContext = (term, context, callback) ->
  doc = {}
  doc[term] = term
  doc['context'] = context
  callback(null, doc)

addDefaultPrefix = (terms, context, callback) ->
  if validator.isURL terms[1]
    callback null, terms
  else if terms[1].indexOf(':') is -1
    prefix = context[terms[0]]["defaultPrefix"]
    terms[1] = prefix + ":" + terms[1]
    callback null, terms
  else
    callback null, terms

expandGroupID = (id, context, callback) ->
  terms = ["group", id]
  expansion.addDefaultPrefix(terms, context)
    .then((terms) -> expansion.addContext(terms[1], context))
    .then(expand)
    .then((expanded) -> expansion.getKey(expanded[0]))
    .then((expandedIRI) -> 
      callback null, expandedIRI)

expandSimpleQuery = (query, context, callback) ->
  expansion.pair(query)
    .then((terms) -> expansion.addDefaultPrefix(terms, context))
    .map((term) -> expansion.addContext(term, context))
    .map((doc) -> expand(doc))
    .then(expansion.extractPredicateAndObject)
    .then((expanded) -> 
      simpleQuery =
        subject: db.v('id')
        predicate: expanded.predicate
        object: expanded.object

      callback(null, simpleQuery))

extractPredicateAndObject = (terms, callback) ->
  expanded =
    predicate: Object.keys(terms[0][0])[0]
    object: Object.keys(terms[1][0])[0]
  callback(null, expanded)

getKey = (obj, callback) ->
  key = Object.keys(obj)[0]
  callback null, key

pair = (obj, callback) ->
  key = Object.keys(obj)[0]
  value = obj[key]
  terms = [key, value]
  callback null, terms

expand = Promise.promisify jsonld.expand

expansion = 
	addContext: Promise.promisify addContext
	addDefaultPrefix: Promise.promisify addDefaultPrefix
	expandGroupID: Promise.promisify expandGroupID
	expandSimpleQuery: Promise.promisify expandSimpleQuery
	extractPredicateAndObject: Promise.promisify extractPredicateAndObject
	getKey: Promise.promisify getKey
	pair: Promise.promisify pair

module.exports = expansion