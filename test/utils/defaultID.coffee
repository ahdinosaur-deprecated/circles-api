expect = require('chai').expect

defaultID = require('../../lib/utils/defaultID')
config = require('../../lib/config')

describe "defaultID", ->
  it "should default shortID", ->
    id = defaultID("loomio")
    expect(id).to.equal("http://open.app/circles/loomio")