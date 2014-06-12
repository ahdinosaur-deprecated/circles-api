validator = require "validator"
expandShorthand = require "./expandShorthand"
Promise = require "bluebird"
jsonld = require "jsonld"
jsonld = jsonld.promises()
_ = require "lodash"

expand = (doc, context, callback) ->
  doc['@context'] = context
  jsonld.expand(doc)
    .then ((expandedDoc) ->
      keys = Object.keys(expandedDoc[0])
      newDoc = {}
      Promise
        .map(keys, (key) ->
          newDoc[key] = expandedDoc[0][key][0]['@value']
          return newDoc
          )
        .nodeify(callback)
      return
      ), (error, expandedDoc) ->
        callback error
        return
  return


module.exports = Promise.promisify expand






