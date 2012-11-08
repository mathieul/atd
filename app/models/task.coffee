EventEmitter2 = require('eventemitter2').EventEmitter2
model = require('lib/model')
StateMachine = require('lib/state-machine')

class Task
  fields: ['uid', 'title', 'completed']

  constructor: (attributes = {}) ->
    attributes.completed ?= false
    model.setupFields(this, @fields, attributes)
    @_emitter = new EventEmitter2
    @_sm = new StateMachine stateMachineConfig,
      changed: (newState, previousState, message) =>
        @_emitter.emit('status-changed', this, newState, previousState)

  status: -> @_sm.state()

  removeAllListeners: (args...) ->
    @_emitter.removeAllListeners(args...)

  on: (args...) ->
    @_emitter.on(args...)

for message in ['queue', 'offer', 'assign', 'complete', 'cancel']
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
