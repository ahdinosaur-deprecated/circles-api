feathers = require('feathers')
associations = require('feathers-associations')

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
  .use('/people', require('open-app-people-api/lib/service')(db))
  .associate('/circles/:circleID/members', ['people'])