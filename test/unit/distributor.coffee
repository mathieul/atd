expect = require('chai').expect
sinon = require('sinon')
EventEmitter2 = require('eventemitter2').EventEmitter2
Distributor = require('distributor')
# Collection = require('lib/collection')
# Queue = require('models/queue')
# Teammate = require('models/teammate')
# Task = require('models/task')

class CollectionMock extends EventEmitter2
  constructor: (@name) ->

# it "listens to queue events (task-queued, task-dequeued to cancel)"
# it "listens to agent events (agent-available, agent-not-available to cancel)"
# it "interacts with the queued tasks state machine (offer, assign, deassign, complete) until they're dequeued"
# it "interacts with the agents state machine"

describe "Distributor:", ->
  beforeEach ->
    @queues = new CollectionMock("Queues")
    @teammates = new CollectionMock("Teammates")

  describe "queues are empty, no agent are available -", (done) ->
    it "it looks for a teammate when a queue emits 'next-task-waiting'", ->
      distributor = new Distributor(@queues, @teammates)
      queue = {name: 'queue'}
      task = {name: 'task'}
      sinon.mock(@teammates).expects('on')
      @queues.emit('next-task-waiting', queue, task)