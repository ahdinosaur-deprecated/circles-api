Joi = require "joi"
Promise = require "bluebird"
url = require "url"


generateContext = (config, callback) ->

  setKeys = (context, config, keys, callback) ->
    keys = config.entity[keys]
    last = keys.length-1
    keys.forEach (key, i) ->
      context[key.key] = key.id
      if i is last
        callback null, context
        return
    return

  setUrl = (context, config, callback) ->
    prefix = config.url.pathname[1..]
    context[prefix] = url.format config.url
    callback null, context


  setKeys = Promise.promisify setKeys
  setUrl = Promise.promisify setUrl
  context = {}

  setKeys(context, config, 'prefixes')
    .then((c) -> setKeys(c, config, 'properties'))
    .then((c) -> setUrl(c, config))
    .then((c) -> callback(null, c))
  return

module.exports = Promise.promisify generateContext