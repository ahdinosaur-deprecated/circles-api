expect = require('chai').expect

addDefaultPrefix = require('../../lib/utils/addDefaultPrefix')
context = require('../../lib/context')

describe "addDefaultPrefix", ->
  it "should default shortID", ->
    addDefaultPrefix([
      "group",
      "loomio",
    ], context).then (terms) ->
      expect(terms).to.deep.equal([
        "group",
        "circles:loomio"
      ])