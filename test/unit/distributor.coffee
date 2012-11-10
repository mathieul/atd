expect = require('chai').expect
Distributor = require('distributor')
Collection = require('lib/collection')
Queue = require('models/queue')
Ability = require('models/ability')
Teammate = require('models/teammate')
Task = require('models/task')
Team = require('models/team')

# it "listens to queue events (task-queued, task-dequeued to cancel)"
# it "listens to agent events (agent-available, agent-not-available to cancel)"
# it "interacts with the queued tasks state machine (offer, assign, deassign, complete) until they're dequeued"
# it "interacts with the agents state machine"

describe "Distributor:", ->
  beforeEach ->
    @team = new Team(name: "Company")
    @queues = @team.queues()
    @teammates = @team.teammates()
    @support = @team.queues().create(name: "Support")
    @joe = @team.teammates().create(uid: "001", name: "Joe")
    @support.assignTeammate(@joe)
    @joe.signIn()

  describe "a queue has a task and an agent is signed in -", ->
    beforeEach ->
      @task = new Task(title: "my printer is not working")
      @support.enqueue(@task)
      @distributor = new Distributor(@queues, @teammates)

    it "offers a queued task to an agent who becomes available'", (done) ->
      @joe.makeAvailable()
      setTimeout =>
        expect(@joe.status()).to.equal 'task_offered'
        expect(@task.status()).to.equal 'offered'
        done()
      , 100

    it "emits an 'offer_task' event", (done) ->
      @distributor.on 'offer_task', (task, queue, teammate) =>
        expect(task).to.deep.equal @task
        expect(queue).to.deep.equal @support
        expect(teammate).to.deep.equal @joe
        done()
      @joe.makeAvailable()

    it "update the task when the agent accepts it", (done) ->
      @joe.makeAvailable()
      @joe.acceptTaskOffered()
      setTimeout =>
        expect(@task.status()).to.equal 'assigned'
        done()
      , 100
