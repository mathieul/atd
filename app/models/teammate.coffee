_ = require('underscore')
ModelMixin = require('lib/model-mixin')

class Teammate
  fields: ['uid', 'name']

  constructor: (args...) ->
    @_initializeModel(args...)

_.extend(Teammate::, ModelMixin)

module.exports = Teammate
