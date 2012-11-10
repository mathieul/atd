_ = require('underscore')
Distributor = require('distributor')
model = require('lib/model')
Collection = require('lib/collection')
Teammate = require('models/teammate')
Queue = require('models/queue')
Ability = require('models/ability')
Task = require('models/task')

class Team
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)

  teammates: (uid) ->
    @_teammates ?= new Collection(Teammate, events: ['status-changed'], owner: {parent: this})
    if uid? then @_teammates.get(uid) else @_teammates

  queues: (query) ->
    @_queues ?= new Collection(Queue, events: ['task-queued'], owner: {parent: this})
    if _.isString(query) or _.isArray(query)
      @_queues.get(query)
    else if query?
      @_queues.pick(query)[0]
    else
      @_queues

  abilities: (query) ->
    @_abilities ?= new Collection(Ability, owner: {parent: this})
    if typeof query is 'string'
      @_abilities.get(query)
    else if query?
      @_abilities.pick(query)[0]
    else
      @_abilities

  tasks: (uid) ->
    @_tasks ?= new Collection(Task, owner: {parent: this})
    if uid? then @_tasks.get(uid) else @_tasks

  distributor: ->
    @_distributor ?= new Distributor(@queues(), @teammates())
    @_distributor

module.exports = Team
