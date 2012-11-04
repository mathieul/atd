_ = require('underscore')
ModelMixin = require('lib/model-mixin')

class Team
  fields: ['uid', 'name']

  constructor: (args...) ->
    @_initializeModel(args...)
    @teammates = {}

  createTeammate: (klass, attributes = null) ->
    if attributes is null
      [attributes, klass] = [klass, require('models/teammate')]
    teammate = new klass(attributes)
    @teammates[teammate.uid] = teammate
    teammate

_.extend(Team::, ModelMixin)

module.exports = Team
