defaultID = require('./defaultID')
alias = require('./alias')
hasType = require('./hasType')

normalizeData = (config, data) ->
  # alias id to @id
  data = alias(data, "id", "@id")
  # default @id
  data["@id"] = defaultID(config.url, data["@id"])
  # alias type to @type
  data = alias(data, "type", "@type")
  # ensure @type has config.type
  data = hasType(data, config.entity.type)

  data

module.exports = normalizeData