expect = require('chai').expect
expandQuery = require '../../lib/utils/expandQuery'
generateContext = require "../../lib/utils/generateContext"
config = require '../../lib/config'

generateContext(config)
  .then((context) ->
    describe "expandQuery", ->
      it "should expand a simple REST query into IRIs", ->
        query =
          "members": "http://open.app/people/simontegg"

        expanded =
          predicate: "http://open.app/relations/members"
          object: "http://open.app/people/simontegg"

        expandQuery(query, context)
          .then((result) ->
            expect(result[0]).to.deep.equal(expanded))
    )



