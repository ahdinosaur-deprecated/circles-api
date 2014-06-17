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
    return

  setType = (context, config, callback) ->
    context['type'] = 
      "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
      "@type":  "http://tools.ietf.org/html/rfc3987"
    callback null, context
    return

  setKeys = Promise.promisify setKeys
  setUrl = Promise.promisify setUrl
  setType = Promise.promisify setType
  context = {}

  setKeys(context, config, 'prefixes')
    .then((c) -> setKeys(c, config, 'properties'))
    .then((c) -> setUrl(c, config))
    .then((c) -> setType(c, config))
    .nodeify(callback)
  return

module.exports = Promise.promisify generateContext