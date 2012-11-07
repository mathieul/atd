model = require('lib/model')
Collection = require('lib/collection')
Teammate = require('models/teammate')
Queue = require('models/queue')

class Team
  fields: ['name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)

  teammates: ->
    @_teammates ||= new Collection(Teammate)

  queues: ->
    @_queues ||= new Collection(Queue)

module.exports = Team
