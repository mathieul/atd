class Distributor
  constructor: (@queues) ->
    @queues.on('next-task-waiting', ->)

module.exports = Distributor
