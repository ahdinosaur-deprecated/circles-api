Promise = require "bluebird"

getKey = (obj, callback) ->
  key = Object.keys(obj)[0]
  callback null, key

module.exports = Promise.promisify getKey