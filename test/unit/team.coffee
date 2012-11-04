expect = require('chai').expect
Team = require('models/team')
Teammate = require('models/teammate')

describe "Team", ->

  describe "- attributes", ->
    it "has a uid", ->
      team = new Team(uid: "abc")
      expect(team.get('uid')).to.equal "abc"
      expect(team.uid).to.equal "abc"

    it "has a name", ->
      team = new Team(name: "Sales")
      expect(team.get('name')).to.equal "Sales"

  describe "- relationships", ->
    beforeEach ->
      @team = new Team(uid: "mi6", name: "Secret Intelligence Service")

    it "creates a new team mate with #createTeammate", ->
      mate = @team.createTeammate(uid: "007", name: "James Bond")
      expect(mate).to.be.an.instanceof(Teammate)
      expect(mate.get('uid')).to.equal "007"
      expect(mate.get('name')).to.equal "James Bond"
