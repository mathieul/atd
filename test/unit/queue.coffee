expect = require('chai').expect
Queue = require('models/queue')

describe "Queue:", ->

  describe "attributes -", ->
    it "has a uid", ->
      queue = new Queue(uid: "ax87")
      expect(queue.uid()).to.equal "ax87"

    it "has a name", ->
      queue = new Queue(name: "Time Passes Quickly")
      expect(queue.name()).to.equal "Time Passes Quickly"
