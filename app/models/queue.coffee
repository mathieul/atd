model = require "lib/model"

class Queue
  fields: ['uid', 'name']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)

module.exports = Queue
