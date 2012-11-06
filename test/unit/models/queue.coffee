expect = require('chai').expect
Queue = require('models/queue')
Teammate = require('models/teammate')
Task = require('models/task')

describe "Queue:", ->

  describe "attributes -", ->
    it "has a uid", ->
      queue = new Queue(uid: "ax87")
      expect(queue.uid()).to.equal "ax87"

    it "has a name", ->
      queue = new Queue(name: "Time Passes Quickly")
      expect(queue.name()).to.equal "Time Passes Quickly"

  describe "teammate assignment -", ->
    beforeEach ->
      @queue = new Queue(uid: "mqrd", name: "Masquerade")
      @mate = new Teammate(uid: "pl01", name: "Player #1")

    describe "#assignTeammate -", ->
      it "creates a capability for a teammate", ->
        ability = @queue.assignTeammate(@mate)
        expect(ability.queueUid()).to.equal @queue.uid()
        expect(ability.teammateUid()).to.equal @mate.uid()

      it "doesn't create a capability if it already exists", ->
        ability1 = @queue.assignTeammate(@mate)
        ability2 = @queue.assignTeammate(@mate)
        expect(ability2).to.equal ability1

      it "sets an ability level", ->
        ability = @queue.assignTeammate(@mate)
        expect(ability.level()).to.equal "low"
        @queue.deassignTeammate(@mate)
        ability = @queue.assignTeammate(@mate, level: "high")
        expect(ability.level()).to.equal "high"

      it "sets an enabled flag for the ability", ->
        ability = @queue.assignTeammate(@mate)
        expect(ability.enabled()).to.be.true
        @queue.deassignTeammate(@mate)
        ability = @queue.assignTeammate(@mate, enabled: false)
        expect(ability.enabled()).to.be.false

    describe "#deassignTeammate -", ->
      beforeEach ->
        @ability = @queue.assignTeammate(@mate)

      it "deletes a capability if it exists", ->
        @queue.deassignTeammate(@mate)
        expect(@queue.abilities()).to.deep.equal []

  describe "handle queueing -", ->
    beforeEach ->
      @queue = new Queue(uid: "mqrd", name: "Masquerade")
      @task = new Task(title: "go north")

    it "enqueues a task with #enqueue", ->
      @queue.enqueue(@task)
      expect(@queue.tasks()).to.deep.equal [@task]

    it "emits an event when a task is queued", (done) ->
      @queue.on 'task-queued', (task, queue) =>
        expect(task).to.equal @task
        expect(queue).to.equal @queue
        done()
      @queue.enqueue(@task)
