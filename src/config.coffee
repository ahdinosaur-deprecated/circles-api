Joi = require('joi')

Agent =
  prefixes: [
    {
      id: "http://xmlns.com/foaf/0.1/",
      key: "foaf"
    }
  ]
  properties: [
    {
      id: "foaf:name",
      key: "name",
      schema: Joi.string().alphanum().required()
    }
  ]
  type: 'foaf:Agent'

Person =
  prefixes: [
    {
      id: "http://xmlns.com/foaf/0.1/",
      key: "foaf"
    }
  ]
  properties: [
    {
      id: "foaf:name",
      key: "name",
      schema: Joi.string().alphanum().required()
    }
  ]
  type: 'foaf:Person'

Circle =
  prefixes: [
    {
      id: "http://xmlns.com/foaf/0.1/",
      key: "foaf"
    }
  ]
  properties: [
    {
      id: "foaf:name",
      key: "name",
      schema: Joi.string().alphanum().required()
    }
  ]
  type: 'foaf:Group'

module.exports = 
  entity:
    prefixes: [
      {
        id: "http://xmlns.com/foaf/0.1/",
        key: "foaf"
      },
      {
        id: "http://open.app/relations/"
        key: "relations"
      },
      {
        id: "https://schema.org/"
        key: "schema"
      }
    ]
    properties: [
      {
        id: "foaf:name",
        key: "name",
        schema: Joi.string().alphanum().required()
      },
      {
        id: "schema:description",
        key: "description",
        schema: Joi.string().alphanum().optional()
      },
      {
        id: "relations:members",
        key: "members"
        schema: Joi.array().optional(),
        type: [Agent, Person, Circle]

      }
    ]
    type: "foaf:Group"
  url: 
    protocol: "http:"
    host: "open.app"
    port: 5000
    pathname: "/circles"






