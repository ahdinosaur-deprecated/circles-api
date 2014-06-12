defaultID = require('./defaultID')
aliasKey = require('./aliasKey')
hasType = require('./hasType')

normalizeData = (config, data) ->
  # alias id to @id
  data = aliasKey(data, "id", "@id")
  # default @id
  data["@id"] = defaultID(config.url, data["@id"])
  # alias type to @type
  data = aliasKey(data, "type", "@type")
  # ensure @type has config.type
  data = hasType(data, config.entity.type)

  data

module.exports = normalizeData