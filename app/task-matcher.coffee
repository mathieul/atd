class TaskMatcher
  constructor: (@_queues) ->

  queues: -> @_queues

module.exports = TaskMatcher
