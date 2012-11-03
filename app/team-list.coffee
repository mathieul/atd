_ = require('underscore')

class TeamList
  constructor: ->
    @length = 0
    @items = []

  add: (team) ->
    @items.push(team)
    @length = @items.length

  get: (id) ->
    _.find(@items, (item) -> item.get('id') is id)

  toArray: ->
    _.clone(@items)

module.exports = TeamList
