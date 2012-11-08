model = require('lib/model')
EventEmitter2 = require('eventemitter2').EventEmitter2
StateMachine = require('lib/state-machine')

class Teammate
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_emitter = new EventEmitter2
    @_sm = new StateMachine stateMachineConfig,
      changed: (newState, previousState, message) =>
        @_emitter.emit('status-changed', this, newState, previousState)

  status: -> @_sm.state()

  on: (args...) ->
    @_emitter.on(args...)

  signIn:        -> @_sm.trigger('sign_in')
  makeAvailable: -> @_sm.trigger('make_available')

stateMachineConfig =
  initial: 'signed_out'
  states: [
    'signed_out'
    'on_break'
    'waiting'
    'task_offered'
    'busy'
    'wrapping_up'
    'other_work'
  ]
  transitions:
    sign_in:
      from: 'signed_out'
      to: 'on_break'
    make_available:
      from: ['on_break', 'wrapping_up', 'other_work']
      to: 'waiting'

module.exports = Teammate
