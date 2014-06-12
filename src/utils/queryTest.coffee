Promise = require "bluebird"
_ = require "lodash"

queryTest = (query) ->

  compliant = (obj) ->
    if "subject" of obj and "predicate" of obj and "object" of obj
      return true
    else
      return false

  if _.isPlainObject query
    if compliant(query)
      return "compliant_query"
    else
      return "uncompliant_query"
  if _.isArray query
    if query.every compliant
      return "compliant_array"
    else
      return "uncompliant_array"

module.exports = queryTest



