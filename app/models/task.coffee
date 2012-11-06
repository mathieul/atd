model = require "lib/model"

class Task
  fields: ['uid', 'title', 'completed']

  constructor: (attributes = {}) ->
    attributes.completed ?= false
    model.setupFields(this, @fields, attributes)

module.exports = Task
