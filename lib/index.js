(function() {
  var Promise, addContext, addTestData, app, complexQuery, context, db, deleteTestData, expand, express, find, get, getMembers, initData, jsonld, jsonldUtil, levelgraph, searchLevelGraph, validator, _;
  express = require("express");
  levelgraph = require("levelgraph");
  validator = require("validator");
  Promise = require("bluebird");
  jsonld = Promise.promisifyAll(require("levelgraph-jsonld"));
  jsonldUtil = require("jsonld");
  expand = Promise.promisify(jsonldUtil.expand);
  _ = require("lodash");
  app = express();
  db = jsonld(levelgraph("../db"));
  initData = require("./initData.js");
  context = require("./context.js");
  app.use(require("body-parser")());
  find = function(query, callback) {
    console.log(query);
    db.search(query, function(error, groups) {
      if (error) {
        return callback(error);
      } else {
        return callback(null, groups);
      }
    });
  };
  addContext = function(doc, context, callback) {
    doc['@context'] = context;
    console.log('doc', doc);
    callback(null, doc);
  };
  find = Promise.promisify(find);
  addContext = Promise.promisify(addContext);
  app.get("/", function(req, res, next) {
    return addTestData(res);
  });
  app.get("/groups", function(req, res, next) {
    var defaultQuery, query;
    query = req.query;
    if (Object.keys(query).length === 0) {
            defaultQuery = {
        subject: db.v('@id'),
        predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
        object: "foaf:group"
      };
      find(defaultQuery).then(function(groups) {
        return res.json(200, groups);
      });;
    } else if (Object.keys(query).length > 1) {
      res.json(400, "GET /groups? only accepts 1 parameter");
    } else {
      return addContext(query, context).then(expand).then(function(expanded) {
        return console.log(JSON.stringify(expanded));
      });
    }
  });
  app.post("/groups", function(req, res, next) {
    var body;
    body = req.body;
    res.json(200, {
      name: "POST /groups"
    });
  });
  app.get("/groups/:id", function(req, res, next) {
    var id;
    id = validator.isURL(id) ? req.params.id : "http://circles.app.enspiral.com/" + req.params.id;
    get(id, res, callback);
  });
  app.put("/groups/:id", function(req, res, next) {
    var body, id;
    id = req.params.id;
    body = req.params.body;
    res.json(200, {
      name: "PUT /groups/" + id
    });
  });
  app["delete"]("/groups/:id", function(req, res, next) {
    var id;
    id = req.params.id;
    db.jsonld.del(id, function(error) {
      return console.log('deleted ' + id);
    });
    return res.json(200, {
      name: "DELETE /groups/" + id
    });
  });
  app.get("/groups/:id/members", function(req, res, next) {
    var id;
    id = validator.isURL(id) ? req.params.id : "http://circles.app.enspiral.com/" + req.params.id;
    return getMembers(res, id, context);
  });
  complexQuery = function(res, queries, queryObj) {};
  searchLevelGraph = function(res, queries) {
    return db.search(queries, function(error, result) {
      if (error != null) {
        res.json(304, {
          data: null,
          message: err
        });
      }
      if (result.length === 0) {
        res.json(200, {
          data: [],
          message: "not found"
        });
      } else {
        res.json(200, {
          data: result,
          message: 'ok'
        });
      }
    });
  };
  get = function(id, res, callback) {
    return db.jsonld.get(id, {
      '@context': context
    }, function(error, result) {
      if (error) {
        return callback(error, null, res);
      } else {
        return callback(null, result, res);
      }
    });
  };
  getMembers = function(res, id, context) {
    return db.jsonld.get(id, {
      '@context': context
    }, function(err, obj) {
      return res.json(200, {
        data: obj['relations:members'],
        message: 'ok'
      });
    });
  };
  addTestData = function(res) {
    return initData.forEach(function(d, i) {
      return db.jsonld.put(d, function(err, obj) {
        if (i === initData.length - 1) {
          return res.json(200, {
            data: initData,
            message: 'test data added'
          });
        }
      });
    });
  };
  deleteTestData = function(res) {
    return db.jsonld.del("http://circles.app.enspiral.com/loomiocommunity", function(error) {
      return res.json(200, {
        data: [],
        message: "data base deleted"
      });
    });
  };
  module.exports = app;
}).call(this);