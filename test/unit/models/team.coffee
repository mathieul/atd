expect = require('chai').expect
Team = require('models/team')

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
      expect(mate).to.be.an.instanceof require('models/teammate')
      expect(@team.teammates("007")).to.deep.equal mate

    it "has a collection of queues", ->
      queue = @team.queues().create(uid: "b777", name: "Diamonds Are Forever")
      expect(queue).to.be.an.instanceof require('models/queue')
      expect(@team.queues("b777")).to.deep.equal queue

    it "has a collection of tasks", ->
      task = @team.tasks().create(uid: "tid01", name: "Buy milk")
      expect(task).to.be.an.instanceof require('models/task')
      expect(@team.tasks("tid01")).to.deep.equal task

    it "has a distributor", ->
      expect(@team.distributor()).to.be.an.instanceof require('distributor')
