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
  type: "foaf:Agent"

module.exports = 
  entity: 
    prefixes: [
      {
        id: "http://xmlns.com/foaf/0.1/",
        key: "foaf"
      },
      {
        id: "http://open.app.com/relations/"
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
        id: "relations:member",
        key: "members"
        schema: Joi.array().optional(),
        type: Agent

      }
    ]
    type: "foaf:Group"
  url: 
    protocol: "http:"
    host: "open.app"
    port: 5000
    pathname: "/circles"






