expect = require('chai').expect
# sinon = require('sinon')
# EventEmitter2 = require('eventemitter2').EventEmitter2
Distributor = require('distributor')
Collection = require('lib/collection')
Queue = require('models/queue')
Teammate = require('models/teammate')
Task = require('models/task')

# class CollectionMock extends EventEmitter2
#   constructor: (@name) ->

# it "listens to queue events (task-queued, task-dequeued to cancel)"
# it "listens to agent events (agent-available, agent-not-available to cancel)"
# it "interacts with the queued tasks state machine (offer, assign, deassign, complete) until they're dequeued"
# it "interacts with the agents state machine"

describe "Distributor:", ->
  beforeEach ->
    @queues = new Collection(Queue)
    @support = @queues.create(name: "Support")
    @teammates = new Collection(Teammate)
    @joe = @teammates.create(uid: "001", name: "Joe")
    @support.assignTeammate(@joe)

  describe "queues are empty, no agent are available -", (done) ->
    it "it offers a queued task to an agent waiting'", ->
      distributor = new Distributor(@queues, @teammates)
      task = new Task(title: "my printer is not working")
      @support.enqueue(task)
      @joe.signIn()

      @joe.makeAvailable()
      expect(task.status()).to.equal 'offered'
      expect(@joe.status()).to.equal 'task_offered'