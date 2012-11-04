_ = require('underscore')

class Teammate
  fields: ['uid', 'name']

  constructor: (attributes = {}) ->
    @attributes = []
    @set(attributes)

  get: (name, value) ->
    return null unless _.include(@fields, name)
    @attributes[name] = value if value?
    @attributes[name]

  set: (attributes) ->
    _(attributes).chain()
      .pick(@fields...)
      .each (value, name) =>
        @id = value if name is 'id'
        @attributes[name] = value

module.exports = Teammate
