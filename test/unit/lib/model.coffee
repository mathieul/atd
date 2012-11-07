expect = require('chai').expect
model = require('lib/model')

class TestModel
  constructor: (attributes) ->
    model.setupFields(this, ['name'], attributes)

describe "Model:", ->
  describe "#setupFields -", ->
    it "create a getter for each field", ->
      test = new TestModel(uid: "abc")
      expect(test.uid()).to.equal "abc"

    it "creates a setter for each field", ->
      test = new TestModel
      test.name("John Zorn")
      expect(test.name()).to.equal "John Zorn"

    it "generate a unique random value for 'uid' field if not set", ->
      test1 = new TestModel
      expect(test1.uid()).to.not.be.an 'undefined'
      test2 = new TestModel
      expect(test2.uid()).to.not.equal test1.uid()

    it "allow to update several fields at once with #set", ->
      test = new TestModel
      test.set(uid: "foo", name: "bar")
      expect(test.uid()).to.equal "foo"
      expect(test.name()).to.equal "bar"
