Joi = require('joi')
Person =
  type: "foaf:person"
  name: {
    context: "foaf:name"
    schema: Joi.string().alphanum().required()
  }



module.exports = {
  entity: {
    type: {
      context: "foaf:Group"
      
    }
    name: {
      context: "foaf:name",
      schema: Joi.string().alphanum().required()
    }
    members: {
      context: "relations:members"
      entity: Person
    }
    sup: {
      context: "foaf:Group"
      entity: "self"

    }
    sub: {
      context: "foaf:Group"
      entity: "self"
    }
    relations: "http://open.app/relations"
  }

  url: {
    protocol: "http:"
    host: "open.app"
    port: 5000
    pathname: "/circles"
  }
} 


module.exports =
  "@language": "en"
  type: 
    "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
    "@type":  "http://tools.ietf.org/html/rfc3987"

  # prefixes
  circles: "http://circles.app.enspiral.com/"
  foaf: "http://xmlns.com/foaf/0.1/"
  people: 
    "@id": "http://people.app.enspiral.com/"
    "@type": "foaf:Person"
  relations: "http://relations.app.enspiral.com/"
  schema: "https://schema.org/"
  
  #properties
  description: "schema:description"
  group: 
    "@id": "foaf:Group"
    "defaultPrefix": "circles"
  image: "foaf:Image"
  name: "foaf:name"
  person: "foaf:Person"

  createdAt:
    "@id": "relations:createdAt"
    "@type": "schema:DateTime"

  modifiedAt:
    "@id": "relations:createdAt"
    "@type": "schema:DateTime"
  
  #relations
  members: 
    "@id": "relations:members"
    "@type": "person"
    "defaultPrefix": "people"
  subgroups:
    "@id": "relations:subgroup"
    "@type": "group"

  supergroups:
    "@id": "relations:supergroup"
    "@type": "group"

