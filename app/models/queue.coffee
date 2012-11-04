_ = require('underscore')
ModelMixin = require('lib/model-mixin')

class Queue
  fields: ['uid', 'name']

  constructor: (args...) ->
    @_initializeModel(args...)

_.extend(Queue::, ModelMixin)

module.exports = Queue
