model = require('lib/model')
StateMachine = require('lib/state-machine')

class Task
  fields: ['uid', 'title', 'completed']

  constructor: (attributes = {}) ->
    attributes.completed ?= false
    model.setupFields(this, @fields, attributes)
    @_sm = new StateMachine(stateMachineConfig)

  status: -> @_sm.state()

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
