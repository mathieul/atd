model = require "lib/model"
Teammate = require('models/teammate')
Queue = require('models/queue')

class Team
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @teammates = {}
    @queues = {}

  createTeammate: (attributes = {}) ->
    klass = attributes.class ? Teammate
    teammate = new klass(attributes)
    @teammates[teammate.uid] = teammate
    teammate

  createQueue: (attributes = {}) ->
    klass = attributes.class ? Queue
    queue = new klass(attributes)
    @queues[queue.uid] = queue
    queue

module.exports = Team
