expect = require('chai').expect
Team = require('team')

describe "Team", ->

  describe "a new instance", ->

    it "has a name", ->
      team = new Team(name: "John Zorn")
      expect(team.get('name')).to.equal "John Zorn"

    it "has an email", ->
      team = new Team(email: "joe@example.com")
      expect(team.get('email')).to.equal "joe@example.com"