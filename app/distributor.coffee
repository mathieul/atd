EventEmitter2 = require('eventemitter2').EventEmitter2
taskMatcher = require('task-matcher')

class Distributor
  constructor: (@queues, @teammates) ->
    @_emitter = new EventEmitter2
    @teammates.on 'status-changed', (teammate, status) =>
      @teammateIsAvailable(teammate) if status is 'waiting'

  teammateIsAvailable: (teammate) ->
    {queue, task} = taskMatcher.findTaskFor(teammate)
    if task?
      teammate.offerTask(task) and task.offer()
      @_emitter.emit('offer_task', task, queue, teammate)

  on: (args...) ->
    @_emitter.on(args...)

module.exports = Distributor
