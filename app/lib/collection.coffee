_ = require('underscore')

class Collection
  normalizeUid = (uid) -> if _.isString(uid) then uid else uid.uid()

  constructor: (@_modelClass, options = {}) ->
    @models = {}
    @length = 0
    @_events = options.events || []
    if options.owner?
      [@ownerAttribute, @owner] = [name, owner] for name, owner of options.owner
    @_callbacks = {}

  create: (attributes) ->
    @add(new @_modelClass(attributes))

  get: (uids) ->
    if _.isArray(uids)
      (@_get(uid) for uid in uids)
    else
      @_get(uids)

  add: (model) ->
    @models[model.uid()] = model
    for event in @_events
      model.on event, (args...) =>
        @_broadcastEvent(event, args)
    @_updateLength()
    model[@ownerAttribute] = @owner if @owner?
    model

  remove: (uid) ->
    uid = normalizeUid(uid)
    model = @models[uid]
    model.removeAllListeners(@_events) if @_events.length > 0
    delete @models[uid]
    @_updateLength()
    model

  pick: (filters) ->
    _.filter @models, (model) ->
      values = {}
      values[name] = model[name]?() for name, expected of filters
      _.isEqual(filters, values)

  on: (event, callback, context = null) ->
    list = @_callbacks[event] ||= []
    list.push([callback, context])

  _get: (uid) ->
    uid = normalizeUid(uid)
    @models[uid]

  _updateLength: ->
    @length = _.size(@models)

  _broadcastEvent: (event, args) ->
    for [callback, context] in (@_callbacks[event] || [])
      callback.apply(context, args)

module.exports = Collection
