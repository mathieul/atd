model = require('lib/model')
Collection = require('lib/collection')
Teammate = require('models/teammate')
Queue = require('models/queue')
Task = require('models/task')

class Team
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_teammates = new Collection(Teammate)
    @_queues = new Collection(Queue)
    @_tasks = new Collection(Task)

  teammates: (uid) ->
    if uid? then @_teammates.get(uid) else @_teammates

  queues: (uid) ->
    if uid? then @_queues.get(uid) else @_queues

  tasks: (uid) ->
    if uid? then @_tasks.get(uid) else @_tasks

module.exports = Team
