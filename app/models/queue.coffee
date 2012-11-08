_ = require('underscore')
EventEmitter2 = require('eventemitter2').EventEmitter2
model = require('lib/model')
Collection = require('lib/collection')
Ability = require('models/ability')

class Queue
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_tasks = []
    @_emitter = new EventEmitter2

  abilities: ->
    @_abilities ||= new Collection(Ability)

  assignTeammate: (teammate, options = {}) ->
    return ability if ability = @_pickForTeammate(teammate)
    attributes = _.extend {}, options,
      queueUid:    @uid()
      teammateUid: teammate.uid()
    @abilities().create(attributes)

  deassignTeammate: (teammate) ->
    ability = @_pickForTeammate(teammate)
    @abilities().remove(ability) if ability?
    ability

  enqueue: (task) ->
    @_tasks.push(task)
    @_emitter.emit('task-queued', task, this)

  tasks: ->
    @_tasks.slice(0)

  on: (args...) ->
    @_emitter.on(args...)

  _pickForTeammate: (teammate) ->
    found = @abilities().pick
      teammateUid: teammate.uid()
      queueUid: @uid()
    found[0]

module.exports = Queue
