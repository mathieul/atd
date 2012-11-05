expect = require('chai').expect
Ability = require('models/ability')

describe "Ability:", ->

  describe "attributes -", ->
    it "has a queue uid", ->
      ability = new Ability(queueUid: "q1")
      expect(ability.queueUid()).to.equal "q1"

    it "has a teammate uid", ->
      ability = new Ability(teammateUid: "m1")
      expect(ability.teammateUid()).to.equal "m1"
