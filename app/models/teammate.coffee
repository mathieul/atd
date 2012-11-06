model = require 'lib/model'
StateMachine = require 'models/teammate/state-machine'

class Teammate
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_sm = new StateMachine

  status: -> @_sm.state()

  signIn: ->
    @_sm.trigger('sign_in')
    this

  makeAvailable: ->
    @_sm.trigger('make_available')
    this

module.exports = Teammate
