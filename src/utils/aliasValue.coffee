Promise = require "bluebird"

aliasValue = (obj, f, callback) ->
  keys = Object.keys(obj)
  console.log 'keys', keys
  for key, i in keys
    console.log 'obj[key]', obj[key]
    if obj[key][0..1] is '@@'

      truncatedValue = obj[key][1..]
      obj[key] = f(truncatedValue)
    if i is keys.length-1
      callback null, obj

module.exports = Promise.promisify aliasValue