model = require "lib/model"

class Queue
  fields: ['queueUid', 'teammateUid']

  constructor: (attributes) ->
    model.setupFields(this, @fields, attributes)

module.exports = Queue
