feathers = require('feathers')

config = require('./config')

# return feathers app
module.exports = (db) ->
  app = feathers()
  #
  # middleware
  #
  .use(require('body-parser')())
  #
  # services
  #
  .use(config.url.pathname, require('./service')(db))

  app