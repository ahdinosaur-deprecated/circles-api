data = [
  "@context":
    "@language": "en"
    type: 
      "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
      "@type":  "http://tools.ietf.org/html/rfc3987"

    # prefixes
    circles: "http://circles.app.enspiral.com/"
    foaf: "http://xmlns.com/foaf/0.1/"
    people: "http://people.app.enspiral.com/"
    relations: "http://relations.app.enspiral.com/"
    schema: "https://schema.org/"
    
    #properties
    description: "schema:description"
    group: "foaf:group"
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
    subgroups:
      "@id": "relations:subgroup"
      "@type": "group"
    supergroups:
      "@id": "relations:supergroup"
      "@type": "group"

  "@id": "circles:loomiocommunity"
  type: "foaf:group"
  name: "Loomio Community"
  createdAt: "2011-12-02T13:13"
  description: "A public group for the whole community of Loomio users\n   and supporters to get together, discuss and collaborate.\n   Find out more about how this community works here:\n   https://www.loomio.org/discussions/5200"
  members: [
    {
      "@id": "people:aaronthornton"
      name: "Aaron Thornton"
    }
    {
      "@id": "people:simontegg"
      name: "Simon Tegg"
    }
  ]
]
module.exports = data