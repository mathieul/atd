_ = require('underscore')

class StateMachine
  config:
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

  constructor: ->
    @loadMachine(@config)

  trigger: (message) ->
    destination = @_transition[message]?[@_current]
    if destination?
      @_current = destination
      true
    else
      false

  state: -> @_current

  loadMachine: (config) ->
    @_current = config.initial
    @_states = config.states
    @_transition = @loadTransitions(config.transitions)

  loadTransitions: (messages) ->
    transitions = {}
    for name, config of messages
      transition = {}
      sources = if _.isArray(config.from) then config.from else [config.from]
      transition[source] = config.to for source in sources
      transitions[name] = transition
    transitions

module.exports = StateMachine
