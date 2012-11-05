expect = require('chai').expect
Team = require('models/team')
Teammate = require('models/teammate')
Queue = require('models/queue')

describe "Team:", ->

  describe "attributes -", ->
    it "has a uid", ->
      team = new Team(uid: "abc")
      expect(team.uid()).to.equal "abc"
      team.uid("ae34")
      expect(team.uid()).to.equal "ae34"

    it "has a name", ->
      team = new Team(name: "Sales")
      expect(team.name()).to.equal "Sales"
      team.name("Ventes")
      expect(team.name()).to.equal "Ventes"

    it "defaults the uid to a random unique id when not set", ->
      team = new Team(name: "Blah")
      expect(team.uid()).to.not.be.an 'undefined'

  describe "relationships -", ->
    beforeEach ->
      @team = new Team(uid: "mi6", name: "Secret Intelligence Service")

    it "creates a new team mate with #createTeammate", ->
      mate = @team.createTeammate(uid: "007", name: "James Bond")
      expect(mate).to.be.an.instanceof(Teammate)
      expect(mate.uid()).to.equal "007"
      expect(mate.name()).to.equal "James Bond"

    it "creates a new queue with #createQueue", ->
      queue = @team.createQueue(uid: "b777", name: "Diamonds Are Forever")
      expect(queue).to.be.an.instanceof(Queue)
      expect(queue.uid()).to.equal "b777"
      expect(queue.name()).to.equal "Diamonds Are Forever"
