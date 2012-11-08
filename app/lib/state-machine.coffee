_ = require('underscore')

class StateMachine
  constructor: (config, @_hooks = {}) ->
    @_current = config.initial
    @_states = _.uniq(config.states.concat(config.initial))
    @_transition = @_loadTransitions(config.transitions)

  trigger: (message) ->
    destination = @_transition[message]?[@_current]
    if destination?
      [previous, @_current] = [@_current, destination]
      @_hooks.changed?(@_current, previous, message)
      true
    else
      false

  state: -> @_current

  states: -> @_states.slice(0)

  _loadTransitions: (messages) ->
    transitions = {}
    for name, config of messages
      transition = {}
      sources = if _.isArray(config.from) then config.from else [config.from]
      transition[source] = config.to for source in sources
      transitions[name] = transition
    transitions

module.exports = StateMachine
