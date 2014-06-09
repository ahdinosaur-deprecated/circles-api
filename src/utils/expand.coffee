validator = require "validator"

expand = (term, context, callback) ->
  if validator.isURL(term)
    callback null, term
  else if term.indexOf(":") > -1
    

