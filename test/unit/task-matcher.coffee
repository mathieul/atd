expect = require('chai').expect

TaskMatcher = require('task-matcher')
Collection = require('lib/collection')
Queue = require('models/queue')
Teammate = require('models/teammate')

describe "TaskMatcher:", ->
  beforeEach ->
    @queues = new Collection(Queue)
    @support = @queues.create(name: "Support")
    @joe = new Teammate(name: "Joe")

  it "is scoped to a queue collection", ->
    matcher = new TaskMatcher(@queues)
    expect(matcher.queues()).to.deep.equal @queues