expect = require('chai').expect

generateContext = require('../../lib/utils/generateContext')
config = require('../../lib/config')

describe "generate context", ->
  it "should generate a json-ld compliant context from a config file", ->

    expectedContext =
      type: 
        "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
        "@type":  "http://tools.ietf.org/html/rfc3987"

      # prefixes
      circles: "http://open.app/circles"
      foaf: "http://xmlns.com/foaf/0.1/"
      relations: "http://open.app/relations/"
      schema: "https://schema.org/"

      #properties
      description: "schema:description"
      name: "foaf:name"
      members: "relations:members"

    generateContext(config)
      .done((generatedContext) -> 
        console.log 'testing generateContext', generatedContext
        expect(generatedContext).to.deep.equal(expectedContext))


