_ = require('underscore')
ModelMixin = require('lib/model-mixin')

class Team
  fields: ['uid', 'name']

  constructor: (args...) ->
    @_initializeModel(args...)
    @teammates = {}
    @queues = {}

  createTeammate: (attributes = {}) ->
    klass = attributes.class ? require('models/teammate')
    teammate = new klass(attributes)
    @teammates[teammate.uid] = teammate
    teammate

  createQueue: (attributes = {}) ->
    klass = attributes.class ? require('models/queue')
    queue = new klass(attributes)
    @queues[queue.uid] = queue
    queue

_.extend(Team::, ModelMixin)

module.exports = Team
