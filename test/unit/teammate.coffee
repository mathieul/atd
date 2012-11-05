expect = require('chai').expect
Teammate = require('models/teammate')

describe "Teammate", ->

  describe "- attributes", ->
    it "has a uid", ->
      mate = new Teammate(uid: "abc")
      expect(mate.uid()).to.equal "abc"

    it "has a name", ->
      mate = new Teammate(name: "John Zorn")
      expect(mate.name()).to.equal "John Zorn"
