Distributor = require('distributor')
model = require('lib/model')
Collection = require('lib/collection')
Teammate = require('models/teammate')
Queue = require('models/queue')
Task = require('models/task')

class Team
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_teammates = new Collection(Teammate, events: ['waiting'])
    @_queues = new Collection(Queue, events: ['task-queued'])
    @_tasks = new Collection(Task)
    @_distributor = new Distributor(@_teammates, @_queues)

  teammates: (uid) ->
    if uid? then @_teammates.get(uid) else @_teammates

  queues: (uid) ->
    if uid? then @_queues.get(uid) else @_queues

  tasks: (uid) ->
    if uid? then @_tasks.get(uid) else @_tasks

  distributor: -> @_distributor

module.exports = Team
