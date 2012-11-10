expect = require('chai').expect
Task = require('models/task')

taskMatcher = require('task-matcher')
Queue = require('models/queue')
Teammate = require('models/teammate')

describe "TaskMatcher:", ->
  it "it returns the next task of the first queue that has one with #findTaskFor", ->
    support = new Queue(name: "Support")
    buyMilk = new Task(title: "buy milk")
    support.enqueue(buyMilk)
    joe = {queues: -> [support]}
    {queue, task} = taskMatcher.findTaskFor(joe)
    expect(task).to.deep.equal buyMilk
    expect(queue).to.deep.equal support
