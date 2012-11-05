_ = require('underscore')
model = require "lib/model"
Ability = require('models/ability')

class Queue
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)
    @_abilities = {}

  abilities: ->
    _.values(@_abilities)

  assignTeammate: (teammate, options = {}) ->
    if (ability = @_abilities[teammate.uid()])
      return ability
    klass = options.class ? Ability
    attributes = _.extend {}, options,
      queueUid:    @uid()
      teammateUid: teammate.uid()
    @_abilities[teammate.uid()] = new klass(attributes)

  deassignTeammate: (teammate) ->
    ability = @_abilities[teammate.uid()]
    delete @_abilities[teammate.uid()] if ability?
    ability

module.exports = Queue
