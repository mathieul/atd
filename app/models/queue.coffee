_ = require('underscore')
EventEmitter2 = require('eventemitter2').EventEmitter2
model = require "lib/model"
Ability = require('models/ability')

class Queue
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_abilities = {}
    @_tasks = []
    @_emitter = new EventEmitter2

  abilities: ->
    _.values(@_abilities)

  assignTeammate: (teammate, options = {}) ->
    if (ability = @_abilities[teammate.uid()])
      return ability
    klass = options.class ? Ability
    attributes = _.extend {}, options,
      queueUid:    @uid()
      teammateUid: teammate.uid()
    @_abilities[teammate.uid()] = new klass(attributes)

  deassignTeammate: (teammate) ->
    ability = @_abilities[teammate.uid()]
    delete @_abilities[teammate.uid()] if ability?
    ability

  enqueue: (task) ->
    @_tasks.push(task)
    @_emitter.emit('task-queued', task, this)

  tasks: ->
    @_tasks.slice(0)

  on: (args...) -> @_emitter.on(args...)

module.exports = Queue
