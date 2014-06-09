Joi = require "joi"
Promise = require "bluebird"


generateContext = (config, callback) ->

	setPrefixes = (config, context, callback) ->
		prefixes = config.entity['prefixes']
		last = prefixes.length-1
		prefixes.forEach (prefix, i) ->
			context[prefix.key] = prefix.id
			if i is last
				callback null, context
				return
		return

	set


	setPrefixes = Promise.promisify setPrefixes
	context = {}

	setPrefixes(config, context)
		.then((c) -> 
			callback(null, c)
			return)
	return

module.exports = Promise.promisify generateContext