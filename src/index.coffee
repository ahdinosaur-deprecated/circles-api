express = require "express"
levelgraph = require "levelgraph"
levelgraphJsonld = require "levelgraph-jsonld"
urlencode = require "urlencode"
validator = require "validator"
Promise = require "bluebird"
jsonld = require "jsonld"
_ = Promise.promisifyAll(require("lodash"))

initData = require "./initData"
context = require "./context"
config = require('./config')

#
# utility functions
#
compact = Promise.promisify jsonld.compact
expand = Promise.promisify jsonld.expand
utils = require "./utils"

# return express app
module.exports = (db) ->
  app = express()

  # setup levelgraph-jsonld db
  db = levelgraphJsonld(levelgraph(db))

  #
  # middleware
  #
  app.use require("body-parser")()

  #
  # CRUD functions
  #
  find = (query, callback) ->
    db.search query, (error, groups) ->
      if error
        callback(error)
      else
        callback(null, groups)

  create = (data, params, callback) ->
    # normalize data
    data = utils.normalizeData(config, data)
    # put group in database
    db.jsonld.put data, (error, group) ->
      # if error, return error
      return callback(error) if error
      # return group
      compact(group, context, callback)

  get = (id, callback) ->
    # normalize id
    id = utils.normalizeID(config, id)
    # get group from database
    db.jsonld.get id, {'@context': context}, (error, group) ->
      if error
        callback error
      else
        callback null, group

  getMembers = (res, id, context) ->
    db.jsonld.get id, {'@context': context}, (err, obj) ->
      res.json 200,
        data: obj['relations:members']
        message: 'ok' 

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
      compact(group, context, callback)

  remove = (id, params, callback) ->
    # normalize id
    id = utils.normalizeID(config, id)
    # delete group in database
    db.jsonld.del id, (error) ->
      return callback error if error
      callback null

  # promisify CRUD functions
  find = Promise.promisify find
  create = Promise.promisify create
  get = Promise.promisify get
  getMembers = Promise.promisify getMembers
  update = Promise.promisify update
  remove = Promise.promisify remove

  #
  # routes
  #
  app.get "/groups", (req, res, next) ->
    query = req.query
    keys = Object.keys(query)
    if keys.length is 0
      defaultQuery =
        subject: db.v('@id')
        predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
        object: config.entity.type

      find(defaultQuery)
        .then((groups) ->
          res.json 200, groups)
      return
    else if keys.length > 1
      res.json 400, "GET /groups? only accepts 1 parameter key-value pair"
      return
    else
      utils.expandSimpleQuery(query, context)
        .then(find)
        .then((groups) ->
          res.json 200, groups)

  app.post "/groups", (req, res, next) ->
    body = req.body
    create(body, null)
      .then((group) -> 
        res.json 201,
          group)
    return

  app.get "/groups/:id", (req, res, next) ->
    id = urlencode.decode req.params.id
    get(id)
      .then((group) ->
        if not group?
          res.json 404, null
        else
          res.json 200, group)
    return

  app.put "/groups/:id", (req, res, next) ->
    id = urlencode.decode req.params.id
    body = req.body
    update(id, body, null)
      .then((group) ->
        res.json 200, group)
    return

  app.delete "/groups/:id", (req, res, next) ->
    id = urlencode.decode req.params.id
    remove(id, null)
      .done(-> 
        res.json 204, null)

  #TODO doesnt work yet
  app.get "/groups/:id/:subResource", (req, res, next) ->
    id = urlencode.decode req.params.id
    subResource = req.params.subResource
    get(id)
      .then(get)
      .then((group) ->
        if not group?
          res.json 404, null
        else
          res.json 200, group[subResource])

  # return express app
  app