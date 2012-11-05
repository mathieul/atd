_ = require('underscore')
crypto = require('crypto')

makeGetterSetter = (obj, name) ->
  obj[name] = (value) ->
    obj.attributes[name] = value if value?
    obj.attributes[name]

randomUid = -> crypto.randomBytes(8).toString('hex')
allIds = {}
generateUid = ->
  uid = randomUid() until allIds[uid] is undefined
  allIds[uid] = true
  uid

module.exports =
  setupFields: (obj, names, attributes = {}) ->
    makeGetterSetter(obj, name) for name in names
    obj.attributes = {uid: generateUid()}
    for name, value of _.pick(attributes, names)
      obj[name](value)
