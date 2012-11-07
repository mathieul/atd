expect = require('chai').expect
Distributor = require('distributor')
Queue = require('models/queue')
Teammate = require('models/teammate')
Task = require('models/task')

describe "Distributor:", ->
  it "listens to queue events (task-queued, task-dequeued to cancel)"
  it "listens to agent events (agent-available, agent-not-available to cancel)"
  it "interacts with the queued tasks state machine (offer, assign, deassign, complete) until they're dequeued"
  it "interacts with the agents state machine"
