EventEmitter2 = require('eventemitter2').EventEmitter2
taskMatcher = require('task-matcher')

class Distributor
  constructor: (@queues, @teammates) ->
    @_emitter = new EventEmitter2
    @teammates.on 'status-changed', (teammate, status) =>
      @offerTask(teammate) if status is 'waiting'
      @assignTask(teammate) if status is 'busy'
      @completeTask(teammate) if status is 'wrapping_up'

  offerTask: (teammate) ->
    {queue, task} = taskMatcher.findTaskFor(teammate)
    if task?
      teammate.offerTask(task) and task.offer()
      @_emitter.emit('offer_task', task, queue, teammate)

  assignTask: (teammate) ->
    task = teammate.currentTask()
    task.assign()
    @_emitter.emit('assign_task', task, task.currentQueue(), teammate)

  completeTask: (teammate) ->
    task = teammate.currentTask()
    task.complete()
    queue = task.currentQueue()
    queue.dequeue(task)
    # TODO: stop using private API when extracting action
    teammate._currentTask = null
    task._currentQueue = null
    @_emitter.emit('complete_task', task, queue, teammate)

  on: (args...) ->
    @_emitter.on(args...)

module.exports = Distributor
