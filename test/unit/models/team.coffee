expect = require('chai').expect
Team = require('models/team')
Teammate = require('models/teammate')
Queue = require('models/queue')

describe "Team:", ->

  describe "attributes -", ->
    it "has a name", ->
      team = new Team(name: "Sales")
      expect(team.name()).to.equal "Sales"
      team.name("Ventes")
      expect(team.name()).to.equal "Ventes"

    it "defaults the uid to a random unique id when not set", ->
      team = new Team(name: "Blah")
      expect(team.uid()).to.not.be.an 'undefined'

  describe "collections -", ->
    beforeEach ->
      @team = new Team(uid: "mi6", name: "Secret Intelligence Service")

    it "has a collection of teammates", ->
      mate = @team.teammates().create(uid: "007", name: "James Bond")
      expect(mate).to.be.an.instanceof(Teammate)
      expect(@team.teammates().get("007")).to.deep.equal mate

    it "has a collection of queues", ->
      queue = @team.queues().create(uid: "b777", name: "Diamonds Are Forever")
      expect(queue).to.be.an.instanceof(Queue)
      expect(@team.queues().get("b777")).to.deep.equal queue
