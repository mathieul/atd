_ = require('underscore')
model = require "lib/model"

class Teammate
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)

module.exports = Teammate
