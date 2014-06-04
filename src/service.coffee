levelgraph = require('levelgraph')
levelgraphJsonld = require('levelgraph-jsonld')
Promise = require('bluebird')
jsonld = require('jsonld')
jsonld = jsonld.promises()

utils = require('./utils/')
context = require('./context')
config = require('./config')

module.exports = service = (db) ->
  # setup levelgraph-jsonld db
  db = levelgraphJsonld(levelgraph(db))

  find = (params, callback) ->
    query = (params && params.query) || {}

    keys = Object.keys(query)

    if keys.length is 0
      defaultQuery =
        subject: db.v('@id')
        predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
        object: config.entity.type

      return find({ query: defaultQuery }, callback)

    # TODO simple query eg. GET /circles?member=simontegg
    #  utils.expandSimpleQuery(query, context)
    #    .then(find)
    #    .then((circles) ->
    #      res.json 200, circles)

    db.search query, (error, circles) ->
      return callback(error) if error
      callback(null, circles)

  create = (data, params, callback) ->
    # normalize data
    data = utils.normalizeData(config, data)
    # put group in database
    db.jsonld.put data, (error, group) ->
      # if error, return error
      return callback(error) if error
      # return group
      jsonld.compact(group, context, callback)

  get = (id, params, callback) ->
    # normalize id
    id = utils.normalizeID(config, id)
    # get group from database
    db.jsonld.get id, context, (error, group) ->
      return callback(error) if error

      if not group
        error = new Error("group " + id + " not found.")
        error.status = 404
        return callback(error)
    
      callback null, group

  update = (id, data, params, callback) ->
    # normalize id and data
    id = utils.normalizeID(config, id)
    data = utils.normalizeData(config, data)
    # if id in route doesn't match id in data, return 400
    if data["@id"] isnt id
      error = new Error("id in route does not match id in data")
      error.status = 400
      return callback(error)
    # put group in database
    db.jsonld.put data, (error, group) ->
      # if error, return error
      return callback(error) if error
      # return group
      jsonld.compact(group, context, callback)

  remove = (id, params, callback) ->
    # normalize id
    id = utils.normalizeID(config, id)
    # delete group in database
    db.jsonld.del id, (error) ->
      return callback error if error
      callback null
  
  return { find, get, create, update, remove }