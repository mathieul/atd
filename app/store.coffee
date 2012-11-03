_ = require('underscore')

class Store
  newCollection = (name) ->
    klass = require("#{name}-list")
    new klass

  constructor: ->
    @collections = {}

  add: (options) ->
    _.each options, (item, name) =>
      collection = @collections[name] ?= newCollection(name)
      collection.add(item)

  get: (options) ->
    name = _.keys(options)[0]
    @collections[name]?.get(options[name])

module.exports = Store
