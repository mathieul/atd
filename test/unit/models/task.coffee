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
