_ = require('underscore')
model = require "lib/model"

class Team
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
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

module.exports = Team
