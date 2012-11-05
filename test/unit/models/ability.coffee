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

    it "has a level, defaults to 'low'", ->
      ability = new Ability
      expect(ability.level()).to.equal "low"
      ability = new Ability(level: "medium")
      expect(ability.level()).to.equal "medium"

    it "has an enabled flag, defaults to true", ->
      ability = new Ability
      expect(ability.enabled()).to.be.true
      ability = new Ability(enabled: false)
      expect(ability.enabled()).to.be.false
