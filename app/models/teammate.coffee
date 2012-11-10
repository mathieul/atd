_ = require('underscore')
model = require('lib/model')
EventEmitter2 = require('eventemitter2').EventEmitter2
StateMachine = require('lib/state-machine')

class Teammate
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_currentTask = null
    @_emitter = new EventEmitter2
    @_sm = new StateMachine stateMachineConfig,
      changed: (newState, previousState, message) =>
        @_emitter.emit('status-changed', this, newState, previousState)

  status: -> @_sm.state()

  queues: ->
    abilities = @parent.abilities().pick(teammateUid: @uid())
    uids = _.map(abilities, (ability) -> ability.queueUid())
    @parent.queues(uids) || []

  on: (args...) ->
    @_emitter.on(args...)

  removeAllListeners: (args...) ->
    @_emitter.removeAllListeners(args...)

  signIn:        -> @_sm.trigger('sign_in')
  makeAvailable: -> @_sm.trigger('make_available')

  offerTask: (task) ->
    @_sm.trigger('offer_task')
    if @status() is 'task_offered'# and task.offer() and task.status() is 'offered'
      @_currentTask = task
      true
    else
      false

  currentTask: -> @_currentTask

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
    offer_task:
      from: 'waiting'
      to: 'task_offered'

module.exports = Teammate
