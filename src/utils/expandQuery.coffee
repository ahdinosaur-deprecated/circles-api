# method to expand a term to its IRI
validator = require "validator"



expandQuery = (query, context, callback) ->
  expanded = {}

  key = Object.keys(query)[0]
  value = query[key]



  if validator.isURL(key)

