_ = require('underscore')
crypto = require('crypto')

makeGetterSetter = (obj, name) ->
  obj[name] = (value) ->
    obj.attributes[name] = value if value?
    obj.attributes[name]

makeMassUpdater = (obj, names) ->
  obj.set = (attributes = {}) ->
    for name, value of _.pick(attributes, names)
      @[name](value)

randomUid = -> crypto.randomBytes(8).toString('hex')
allIds = {}
generateUid = ->
  uid = randomUid() until allIds[uid] is undefined
  allIds[uid] = true
  uid

module.exports =
  setupFields: (obj, names, attributes = {}) ->
    makeGetterSetter(obj, name) for name in names
    makeMassUpdater(obj, names)
    obj.attributes = {uid: generateUid()}
    obj.set(attributes)
