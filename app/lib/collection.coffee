_ = require('underscore')

class Collection
  normalizeUid = (uid) -> if _.isString(uid) then uid else uid.uid()

  constructor: (@_modelClass) ->
    @models = {}
    @length = 0

  create: (attributes) ->
    @add(new @_modelClass(attributes))

  get: (uid) ->
    uid = normalizeUid(uid)
    @models[uid]

  add: (model) ->
    @models[model.uid()] = model
    @_updateLength()
    model

  remove: (uid) ->
    uid = normalizeUid(uid)
    model = @models[uid]
    delete @models[uid]
    @_updateLength()
    model

  pick: (filters) ->
    _.filter @models, (model) ->
      values = {}
      values[name] = model[name]?() for name, expected of filters
      _.isEqual(filters, values)

  _updateLength: ->
    @length = _.size(@models)

module.exports = Collection
