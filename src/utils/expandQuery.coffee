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
      if not key?
        return []
      value = obj[key]
      return {
        subject: "@@id"
        predicate: key
        object: value
      })
    .nodeify(callback)

module.exports = Promise.promisify expandQuery








