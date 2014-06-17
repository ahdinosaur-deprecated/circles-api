# method to expand a simple query to a query compliant with levelgraph search 
validator = require "validator"
config = require "../config"
expand = require "./expand"
Promise = require "bluebird"
_ = require "lodash"

expandQuery = (queryObj, context, callback) ->
  callback null, [] if Object.keys(queryObj).length is 0

  expand(queryObj, context)
    .then((queries) ->

      Promise.map(queries, (query) ->
        if _.isPlainObject query
          key = Object.keys(query)[0]
          return {
            subject: "@@id"
            predicate: key
            object: query[key]
          }
        else
          error = new Error "query isn't an object"
        ))
    .nodeify(callback)
  return

module.exports = Promise.promisify expandQuery








