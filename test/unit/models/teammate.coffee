expect = require('chai').expect
Teammate = require('models/teammate')
Collection = require('lib/collection')
Queue = require('models/queue')
Ability = require('models/ability')
Team = require('models/team')
Task = require('models/task')

describe "Teammate:", ->

  describe "attributes -", ->
    it "has a name", ->
      mate = new Teammate(name: "John Zorn")
      expect(mate.name()).to.equal "John Zorn"

  describe "status management -", ->
    beforeEach ->
      @mate = new Teammate(name: "Joey Baron")

    it "has a status 'signed_out' when not signed in", ->
      expect(@mate.status()).to.equal 'signed_out'

    it "can sign in", ->
      @mate.signIn()
      expect(@mate.status()).to.equal 'on_break'

    it "can become available", ->
      @mate.makeAvailable()
      expect(@mate.status()).to.equal 'signed_out'

      @mate.signIn()
      @mate.makeAvailable()
      expect(@mate.status()).to.equal 'waiting'

    it "triggers an event when changing status", (done) ->
      @mate.on "status-changed", (teammate, status, previous) =>
        expect(teammate).to.deep.equal @mate
        expect(status).to.equal 'on_break'
        expect(previous).to.equal 'signed_out'
        done()
      @mate.signIn()

  describe "relationships -", ->
    beforeEach ->
      @team = new Team(name: "Masada")
      @mate = new Teammate(name: "Greg Cohen")
      @mate.parent = @team
      @task = new Task(name: "Buy eggs")
      @task.queue()
      @mate.signIn()

    it "can be assigned to queues through abilities", ->
      expect(@mate.queues().length).to.equal 0
      q1 = @team.queues().create(name: 'q1')
      q2 = @team.queues().create(name: 'q2')
      q1.assignTeammate(@mate)
      expect(@mate.queues()).to.deep.equal [q1]

    it "can be offered a task with #offerTask", ->
      @mate.offerTask(@task)
      expect(@mate.status()).to.equal "on_break"

      @mate.makeAvailable()
      @mate.offerTask(@task)
      expect(@mate.status()).to.equal "task_offered"
      expect(@mate.currentTask()).to.deep.equal @task

    it "can accept a task with #acceptTaskOffered", ->
      @mate.makeAvailable()
      @mate.offerTask(@task)
      @mate.acceptTaskOffered()
      expect(@mate.status()).to.equal "busy"

    it "can finish the task currently assigned", ->
      @mate.makeAvailable()
      @mate.offerTask(@task)
      @mate.acceptTaskOffered()
      @mate.finishTask()
      expect(@mate.status()).to.equal "wrapping_up"

    it "can start some other work", ->
      @mate.makeAvailable()
      @mate.offerTask(@task)
      @mate.acceptTaskOffered()
      @mate.finishTask()
      @mate.startOtherWork()
      expect(@mate.status()).to.equal "other_work"

    it "can go on a break", ->
      @mate.makeAvailable()
      @mate.goOnBreak()
      expect(@mate.status()).to.equal "on_break"

    it "can sign out", ->
      @mate.goOnBreak()
      @mate.signOut()
      expect(@mate.status()).to.equal "signed_out"
