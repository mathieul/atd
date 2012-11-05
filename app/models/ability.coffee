model = require "lib/model"

class Ability
  fields: ['queueUid', 'teammateUid', 'level', 'enabled']

  constructor: (attributes = {}) ->
    attributes.level ?= "low"
    attributes.enabled ?= true
    model.setupFields(this, @fields, attributes)

module.exports = Ability
