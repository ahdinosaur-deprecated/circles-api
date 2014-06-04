Promise = require('bluebird')

# TODO is this _.zip?
pair = (obj, callback) ->
  key = Object.keys(obj)[0]
  value = obj[key]
  terms = [key, value]
  callback null, terms

module.exports = Promise.promisify pair