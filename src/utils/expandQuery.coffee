# method to expand a term to its IRI
validator = require "validator"
config = require "../config"
expand = require "./expand"
Promise = require "bluebird"
_ = require "lodash"

expandQuery = (queryObj, context, callback) ->
  expand(queryObj, context)
    .map((obj) ->
      key = Object.keys(obj)[0]
      value = obj[key]
      return {
        predicate: key
        object: value
      })
    .nodeify(callback)

module.exports = Promise.promisify expandQuery








