levelgraph = require('levelgraph')
levelgraphJsonld = require('levelgraph-jsonld')
Promise = require('bluebird')
jsonld = require('jsonld')
jsonld = jsonld.promises()

utils = require('./utils/')
aliasValue = require('./utils/aliasValue')
context = require('./context')
config = require('./config')


queryTest = require('./utils/queryTest')
expandQuery = require('./utils/expandQuery')
#baseQuery = require('./utils/baseQuery')

module.exports = service = (db) ->
  # setup levelgraph-jsonld db
  db = levelgraphJsonld(levelgraph(db))

  find = (params, callback) ->
    query = (params && params.query) || {}

    switch queryTest query
      when "uncompliant_query"
        expandQuery(query, context)
          .map((expandedQuery) ->
            console.log 'expandedQuery', expandedQuery
            return aliasValue(expandedQuery, db.v))
          .then((compliantQueries) ->
            baseQuery =
              subject: db.v('@id')
              predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
              object: 'http://xmlns.com/foaf/0.1/Group'
 
            compliantQueries.push baseQuery
            return find({ query: compliantQueries }, callback))
      when "compliant_query"
        return find({ query: [query] }, callback)
      when "uncompliant_array"
        error = new Error "your query is messed up"
        callback error
      when "compliant_array"
        db.search query, (error, circles) ->
          console.log error
          return callback(error) if error
          console.log 'found circles', circles
          callback(null, circles)

  create = (data, params, callback) ->
    # normalize data
    data = utils.normalizeData(config, data)
    console.log 'putting data', data
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