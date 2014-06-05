Joi = require('joi')

module.exports = {
  entity: {
    type: "foaf:Group"
    name: {
      context: "foaf:name",
      schema: Joi.string().alphanum().required()
    }
  }
  url: {
    protocol: "http:"
    host: "open.app"
    port: 5000
    pathname: "/circles"
  }
} 