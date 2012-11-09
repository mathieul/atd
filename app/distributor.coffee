TaskMatcher = require('task-matcher')

class Distributor
  constructor: (@queues, @teammates) ->
    @teammates.on 'status-changed', (teammate, status) =>
      @teammateIsAvailable(teammate) if status is 'waiting'

  teammateIsAvailable: (teammate) ->
    matcher = new TaskMatcher(teammate.queues())
    task = matcher.findTaskFor(teammates)
    @assign(task, teammate) if task?

module.exports = Distributor
