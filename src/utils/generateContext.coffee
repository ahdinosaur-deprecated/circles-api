Joi = require "joi"
Promise = require "bluebird"


generateContext = (config, callback) ->

	setKeys = (context, config, keys, callback) ->
		keys = config.entity[keys]
		last = keys.length
		keys.forEach (key, i) ->
			context[key.key] = key.id
			if i is last
				callback null, context
				return
		return

	setKeys = Promise.promisify setKeys
	context = {}

	setKeys(context, config, 'prefixes')
		.then((c) -> setKeys(c, config, 'properties'))
		.then((c) -> callback(null, c))
	return

module.exports = Promise.promisify generateContext