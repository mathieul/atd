_ = require('underscore')
EventEmitter2 = require('eventemitter2').EventEmitter2
model = require('lib/model')
Collection = require('lib/collection')

class Queue
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_tasks = []
    @_emitter = new EventEmitter2

  abilities: ->
    @parent?.abilities()

  assignTeammate: (teammate, options = {}) ->
    return ability if ability = @_findForTeammate(teammate)
    attributes = _.extend {}, options,
      queueUid:    @uid()
      teammateUid: teammate.uid()
    @abilities().create(attributes)

  deassignTeammate: (teammate) ->
    ability = @_findForTeammate(teammate)
    @abilities().remove(ability) if ability?
    ability

  enqueue: (task) ->
    task.queue(this)
    return false unless task.status() is 'queued'
    @_tasks.push(task)
    @_emitter.emit('task-queued', task, this)

  dequeue: (taskToRemove) ->
    @_tasks = _.reject @_tasks, (task) -> task.uid() is taskToRemove.uid()
    @_emitter.emit('task-dequeued', taskToRemove, this)

  tasks: ->
    @_tasks

  nextTask: ->
    @_tasks[0] || null

  on: (args...) ->
    @_emitter.on(args...)

  removeAllListeners: (args...) ->
    @_emitter.removeAllListeners(args...)

  _findForTeammate: (teammate) ->
    found = @abilities().pick
      teammateUid: teammate.uid()
      queueUid: @uid()
    found[0]

module.exports = Queue
