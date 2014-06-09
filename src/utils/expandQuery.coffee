# method to expand a term to its IRI
validator = require "validator"
config = require "../config"
expand = require "./expand"
Promise = require "bluebird"

expandQuery = (queryObj, context, callback) ->
  keys = Object.keys queryObj
  Promise.map(keys, (key) ->
    if validator.isURL queryObj[key]
      expand(key, context)
        .then( (expandedKey) -> 
          return {
            predicate: expandedKey
            object: queryObj[key]
            })
    else
      error = new Error "Query value is not a valid IRI"
      callback error
    )
    .nodeify(callback)








