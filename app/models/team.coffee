_ = require('underscore')

class Team
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
        @uid = value if name is 'uid'
        @attributes[name] = value

  createTeammate: ->

module.exports = Team
