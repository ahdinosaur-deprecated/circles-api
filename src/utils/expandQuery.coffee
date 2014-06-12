# method to expand a simple query to a query compliant with levelgraph search 
validator = require "validator"
config = require "../config"
expand = require "./expand"
Promise = require "bluebird"
_ = require "lodash"

expandQuery = (queryObj, context, callback) ->
  callback null, [] if Object.keys(queryObj).length is 0
  expand(queryObj, context)
    .map((obj) ->
      key = Object.keys(obj)[0]
      value = obj[key]
      return {
        subject: "@@id"
        predicate: key
        object: value
      })
    .nodeify(callback)
  return

module.exports = Promise.promisify expandQuery








