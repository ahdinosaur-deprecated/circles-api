getMembers: (db, id, context, callback) ->
  db.jsonld.get id, {'@context': context}, (err, obj) ->
    callback(err) if err
    callback null,
      data: obj['relations:members']
      message: 'ok' 

module.exports = getMembers