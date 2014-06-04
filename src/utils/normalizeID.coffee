defaultID = require('./defaultID')

normalizeID = (config, id) ->
  # default id
  id = defaultID(config.url, id)

  id

module.exports = normalizeID