request = require("supertest")
expect = require("chai").expect
urlencode = require("urlencode")

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

describe "#groups", ->
  before ->
    db = require("level-test")()("testdb")
    graphdb = require('levelgraph-jsonld')(require('levelgraph')(db))
    app = require('../')(db)
    request = request(app)
    return

  it "should POST /groups", (done) ->
    body = undefined

    request
    .post("/groups")
    .send(group)
    .expect("Content-Type", /json/)
    .expect(201)
    .expect (req) ->
      ## why is it an array?
      body = req.body[0]
      for prop of body
        expect(body).to.have.property prop, group[prop]
      return
    .end (err, res) ->
      return done(err) if err
      graphdb.jsonld.get body.id, context, (err, body) ->
        return done(err) if err
        for prop of body
          expect(body).to.have.property prop, group[prop]
        done()

  it "should GET /groups", (done) ->

    graphdb.jsonld.put group, (err) ->
      expect(err).to.not.exist

      request
      .get("/groups")
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

  it "should GET /groups/:id", (done) ->
      graphdb.jsonld.put group, (err, obj) ->
        expect(err).to.not.exist

        request
        .get("/groups/" + urlencode(obj['@id']))
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

  it "should GET /groups/:shortID", (done) ->
    graphdb.jsonld.put group, (err, obj) ->
        expect(err).to.not.exist

        request
        .get("/groups/" + urlencode('loomiocommunity'))
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

  it "should PUT /groups/:id", (done) ->
    body = undefined

    request
    .put("/groups/" + urlencode(group['@id']))
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
#  it "should GET /groups/:id/members", (done) ->
#    request
#    .get("/groups/" + urlencode(group['@id']) + "/members")
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

  it "should DELETE /groups/:id", (done) ->

    graphdb.jsonld.put group, (err, obj) ->
      expect(err).to.not.exist
      expect(obj).to.exist

      request
      .del("/groups/" + urlencode(group['@id']))
      .expect(204)
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
