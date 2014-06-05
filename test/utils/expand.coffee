expect = require('chai').expect

expand = require('../../lib/utils/expand')
config = require('../../lib/config')

describe "expand", ->
  it "should expand a simple REST query into IRIs", ->
  	query =
  		"members": "simontegg"

  	expanded =
  		predicate: "http://relations.enspiral.com/members"
  		object: "http://people.enspiral.com/simontegg"

  	result = expand(query)

  	expect(result).to.equal(expanded)