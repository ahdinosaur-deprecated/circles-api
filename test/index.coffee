request = require("supertest")
expect = require("chai").expect
urlencode = require("urlencode")
require('longjohn')

context = require('../lib/context')
config = require('../lib/config')

utils = require('../lib/utils/')

app = undefined
db = undefined
graphdb = undefined
# group = undefined 

group =
  id: "http://circles.app.enspiral.com/loomiocommunity"
  name: "Loomio Community"
  'http://xmlns.com/foaf/0.1/based_near': "http://www.geonames.org/2179537/wellington.html"
  'http://open.app/relations/members': [
    {
      "@id": "http://open.app/people/aaronthornton"
#      name: "Aaron Thornton"
    },
    {
      "@id": "http://open.app/people/simontegg"
#      name: "Simon Tegg"
    }
  ]


bestGroup =
  id: "http://circles.app.enspiral.com/bestgroup"
  name: "Best Group"
  based_near: "http://www.geonames.org/2179537/wellington.html"
  members: [
    {
      "@id": "http://open.app/people/simontegg"
    }


  ]

describe "#circles", ->
  before ->
    db = require("level-test")()("testdb")
    graphdb = require('levelgraph-jsonld')(require('levelgraph')(db))
    app = require('../')(db)
    request = request(app)
    return

  it "should POST /circles", (done) ->
    request
    .post("/circles")
    .send(group)
    .expect("Content-Type", /json/)
    .expect(200) # TODO 201
    .end (err, res) ->
      return done(err) if err
      graphdb.jsonld.get group['@id'], context, (err, body) ->
        return done(err) if err
        for prop of body
          expect(body).to.have.property prop, group[prop]
        done()

  it "should GET /circles", (done) ->

    data = utils.normalizeData(config, group)

    graphdb.jsonld.put data, (err) ->
      expect(err).to.not.exist
      console.log 'putted group', group

      request
      .get("/circles")
      .expect("Content-Type", /json/)
      .expect(200)
      .expect (req) ->
        body = req.body
        expect(body).to.have.length(1)
        for prop of body[0]
          expect(body[0]).to.have.property prop, group[prop]
        return
      .end (err, res) ->
        return done(err) if err
        done()

  # it "should GET /circles?members=http%3A%2F%2Fopen.app%2Fpeople%2Faaronthornton", (done) ->
    
  #   data = utils.normalizeData(config, group)

  #   graphdb.jsonld.put data, (err) ->
  #     expect(err).to.not.exist
  #     console.log data

  #     request
  #     .get("/circles?&name=" + urlencode(group['name']))
  #     .expect("Content-Type", /json/)
  #     .expect(200)
  #     .expect (req) ->
  #       body = req.body
  #       expect(body).to.have.length(1)
  #       for prop of body[0]
  #         expect(body[0]).to.have.property prop, group[prop]
  #       return
  #     .end (err, res) ->
  #       return done(err) if err
  #       done()

  # it "should GET /circles?members=http%3A%2F%2Fopen.app%2Fpeople%2Fsimontegg&based_near=http://www.geonames.org/2179537/wellington.html", (done) ->
    
  #   data = utils.normalizeData(config, group)

  #   graphdb.jsonld.put data, (err) ->
  #     expect(err).to.not.exist
  #     console.log 'putted group', data

  #     request
  #     .get("/circles?members=" + urlencode(group['http://open.app/relations/members'][1]["@id"]) + "&based_near=" + urlencode(group['http://xmlns.com/foaf/0.1/based_near']))
  #     .expect("Content-Type", /json/)
  #     .expect(200)
  #     .expect (req) ->
  #       body = req.body
  #       expect(body).to.have.length(1)
  #       for prop of body[0]
  #         expect(body[0]).to.have.property prop, group[prop]
  #       return
  #     .end (err, res) ->
  #       return done(err) if err
  #       done()    

#   it "should GET /circles/:id", (done) ->
#       graphdb.jsonld.put group, (err, obj) ->
#         expect(err).to.not.exist

#         request
#         .get("/circles/" + urlencode(obj['@id']))
#         .expect("Content-Type", /json/)
#         .expect(200)
#         .expect((req) ->
#           body = req.body
#           for prop of body
#             expect(body).to.have.property prop, group[prop]
#           return)
#         .end((err, res) ->
#           return done(err)  if err
#           done())

#   it "should PUT /circles/:id", (done) ->
#     body = undefined

#     request
#     .put("/circles/" + urlencode(group['@id']))
#     .send(group)
#     .expect("Content-Type", /json/)
#     .expect(200)
#     .expect((req) ->
#       body = req.body
#       for prop of body
#         expect(body).to.have.property prop, group[prop]
#       return)
#     .end (err, res) ->
#       graphdb.jsonld.get body.id, context, (err, body) ->
#         return done(err) if err
#         for prop of body
#           expect(body).to.have.property prop, group[prop]
#         done()

#   #TODO
# #  it "should GET /circles/:id/members", (done) ->
# #    request
# #    .get("/circles/" + urlencode(group['@id']) + "/members")
# #    .expect("Content-Type", /json/)
# #    .expect(200)
# #    .expect((req) ->
# #      body = req.body
# #      console.log body, 'members'
# #      expect(body).to.contain.keys '@id', "name"
# #      return)
# #    .end((err, res) ->
# #      return done(err)  if err
# #      done())

#   it "should DELETE /circles/:id", (done) ->

#     graphdb.jsonld.put group, (err, obj) ->
#       expect(err).to.not.exist
#       expect(obj).to.exist

#       request
#       .del("/circles/" + urlencode(group['@id']))
#       .expect(200) # TODO 204
#       .end (err, res) ->
#         graphdb.jsonld.get obj['@id'], context, (err, body) ->
#           expect(err).to.not.exist
#           expect(body).to.not.exist
#           done()

#   afterEach (done) ->
#       # del all objects in db
#       db.createKeyStream()
#       .on 'data', (k) ->
#         db.del(k)
#       .on 'close', ->
#         done()

  @
