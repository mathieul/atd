EventEmitter2 = require('eventemitter2').EventEmitter2
model = require('lib/model')
StateMachine = require('lib/state-machine')

class Task
  fields: ['title']

  constructor: (attributes = {}) ->
    model.setupFields(this, @fields, attributes)
    @_currentQueue = null
    @_emitter = new EventEmitter2
    @_sm = new StateMachine stateMachineConfig,
      changed: (newState, previousState, message) =>
        @_emitter.emit('status-changed', this, newState, previousState)

  status: -> @_sm.state()

  removeAllListeners: (args...) ->
    @_emitter.removeAllListeners(args...)

  on: (args...) ->
    @_emitter.on(args...)

  queue: (queue) ->
    @_sm.trigger('queue')
    @_currentQueue = queue if @_sm.state() is 'queued'

  currentQueue: -> @_currentQueue

for message in ['offer', 'assign', 'complete', 'cancel']
  Task::[message] = do (message) -> (-> @_sm.trigger message)

stateMachineConfig =
  initial: 'created'
  states: [
    'queued'
    'offered'
    'assigned'
    'completed'
    'cancelled'
  ]
  transitions:
    queue:
      from: 'created'
      to: 'queued'
    offer:
      from: 'queued'
      to: 'offered'
    assign:
      from: ['queued', 'offered']
      to: 'assigned'
    complete:
      from: 'assigned'
      to: 'completed'
    cancel:
      from: ['queued', 'offered']
      to: 'cancelled'

module.exports = Task
