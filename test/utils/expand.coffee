expect = require('chai').expect
expand = require '../../lib/utils/expand'
generateContext = require "../../lib/utils/generateContext"
config = require '../../lib/config'

generateContext(config)
  .then((context) ->
    describe "expand", ->
      it "should expand a simple REST query into IRIs", ->
        query =
          "members": "simontegg"

        expanded =
          predicate: "http://open.app/relations/members"
          object: "http://open.app/people/simontegg"

        result = expand(query, context)

        expect(result).to.deep.equal(expanded))



