Promise = require "bluebird"
_ = require "lodash"

queryTest = (query) ->

  compliant = (obj) ->
    if "subject" in obj and "predicate" in obj and "object" in obj
      return true
    else
      return false

  if _.isPlainObject query
    if compliant(query)
      return "compliant_query_object"
    else
      return "uncompliant_query"
  if _.isArray query
    if _.every query, compliant
      return "compliant_array"
    else
      return "uncompliant_array"

module.exports = queryTest



