_ = require('underscore')

uids = 1

ModelMixin =
  _initializeModel: (attributes = {}) ->
    @attributes = []
    attributes.uid ?= (uids += 1)  # TODO: make that more robust (uuid?)
    @set(attributes)

  get: (name, value) ->
    return null unless _.include(@fields, name)
    @attributes[name] = value if value?
    @attributes[name]

  set: (attributes) ->
    _(attributes).chain()
      .pick(@fields...)
      .each (value, name) =>
        @uid = value if name is 'uid'
        @attributes[name] = value

module.exports = ModelMixin
