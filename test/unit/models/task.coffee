expect = require('chai').expect
Task = require('models/task')

describe "Task:", ->

  describe "attributes -", ->
    it "has a title", ->
      task = new Task(title: "finish the game")
      expect(task.title()).to.equal "finish the game"

    it "has a completed flag, defaults to false", ->
      task = new Task
      expect(task.completed()).to.be.false
      task.completed(true)
      expect(task.completed()).to.be.true

  describe "status management -", ->
    beforeEach ->
      @task = new Task(title: "Stateful")

    it "has a status 'created' by default", ->
      expect(@task.status()).to.equal 'created'

    it "changes to queued with #queue", ->
      @task.queue()
      expect(@task.status()).to.equal 'queued'

    it "changes to offered if queued, with #offer", ->
      @task.queue()
      @task.offer()
      expect(@task.status()).to.equal 'offered'

    it "changes to assigned if queued or offered, with #assign", ->
      @task.queue()
      @task.assign()
      expect(@task.status()).to.equal 'assigned'

    it "changes to completed if assigned, with #complete", ->
      @task.queue(); @task.assign()
      @task.complete()
      expect(@task.status()).to.equal 'completed'

    it "changes to cancelled if queued or offered, with #cancel", ->
      @task.queue(); @task.offer()
      @task.cancel()
      expect(@task.status()).to.equal 'cancelled'
