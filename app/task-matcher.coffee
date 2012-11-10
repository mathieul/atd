_ = require('underscore')

taskMatcher =
  findTaskFor: (teammate) ->
    queue = _.find teammate.queues(), (queue) ->
      queue.tasks().length > 0
    if queue
      {queue: queue, task: queue.nextTask()}
    else
      {}

module.exports = taskMatcher
