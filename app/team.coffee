_ = require('underscore')

class Team
  fields: ['name', 'email']

  constructor: (attributes = {}) ->
    @attributes = _.pick(attributes, @fields...)

  get: (name, value) ->
    return null unless _.include(@fields, name)
    @attributes[name] = value if value?
    @attributes[name]

module.exports = Team