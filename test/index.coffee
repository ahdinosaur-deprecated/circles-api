request = require("supertest")
expect = require("chai").expect
urlencode = require("urlencode")
require('longjohn')

context = require('../lib/context')

app = undefined
db = undefined
graphdb = undefined
# group = undefined 

group =
  '@id': "http://open.app/circles/loomiocommunity"
  '@type': "foaf:Group"
  name: "Loomio Community"
  members: [
    {
      "@id": "people:aaronthornton"
#      name: "Aaron Thornton"
    },
    {
      "@id": "people:simontegg"
#      name: "Simon Tegg"
    }
  ]


bestGroup =
  id: "http://circles.app.enspiral.com/bestgroup"
  name: "Best Group"

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

    graphdb.jsonld.put group, (err) ->
      expect(err).to.not.exist

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

  it "should GET /circles/:id", (done) ->
      graphdb.jsonld.put group, (err, obj) ->
        expect(err).to.not.exist

        request
        .get("/circles/" + urlencode(obj['@id']))
        .expect("Content-Type", /json/)
        .expect(200)
        .expect((req) ->
          body = req.body
          for prop of body
            expect(body).to.have.property prop, group[prop]
          return)
        .end((err, res) ->
          return done(err)  if err
          done())

  it "should GET /circles/:shortID", (done) ->
    graphdb.jsonld.put group, (err, obj) ->
        expect(err).to.not.exist

        request
        .get("/circles/" + urlencode('loomiocommunity'))
        .expect("Content-Type", /json/)
        .expect(200)
        .expect((req) ->
          body = req.body
          for prop of body
            expect(body).to.have.property prop, group[prop]
          return)
        .end((err, res) ->
          return done(err)  if err
          done())

  it "should PUT /circles/:id", (done) ->
    body = undefined

    request
    .put("/circles/" + urlencode(group['@id']))
    .send(group)
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      for prop of body
        expect(body).to.have.property prop, group[prop]
      return)
    .end (err, res) ->
      graphdb.jsonld.get body.id, context, (err, body) ->
        return done(err) if err
        for prop of body
          expect(body).to.have.property prop, group[prop]
        done()

  #TODO
#  it "should GET /circles/:id/members", (done) ->
#    request
#    .get("/circles/" + urlencode(group['@id']) + "/members")
#    .expect("Content-Type", /json/)
#    .expect(200)
#    .expect((req) ->
#      body = req.body
#      console.log body, 'members'
#      expect(body).to.contain.keys '@id', "name"
#      return)
#    .end((err, res) ->
#      return done(err)  if err
#      done())

  it "should DELETE /circles/:id", (done) ->

    graphdb.jsonld.put group, (err, obj) ->
      expect(err).to.not.exist
      expect(obj).to.exist

      request
      .del("/circles/" + urlencode(group['@id']))
      .expect(200) # TODO 204
      .end (err, res) ->
        graphdb.jsonld.get obj['@id'], context, (err, body) ->
          expect(err).to.not.exist
          expect(body).to.not.exist
          done()

  afterEach (done) ->
      # del all objects in db
      db.createKeyStream()
      .on 'data', (k) ->
        db.del(k)
      .on 'close', ->
        done()

  @
