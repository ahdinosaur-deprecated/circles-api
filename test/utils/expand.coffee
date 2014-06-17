expect = require('chai').expect
expand = require '../../lib/utils/expand'
generateContext = require "../../lib/utils/generateContext"
config = require '../../lib/config'

generateContext(config)
  .then((context) ->
    describe "expand", ->
      it "should expand an object's terms to their full IRIs ", ->
        query =
          "members": "http://open.app/people/simontegg"

        expanded =
          "http://open.app/relations/members": "http://open.app/people/simontegg"

        expand(query, context)
          .then((result) ->
            expect(result[0]).to.deep.equal(expanded))
    )



