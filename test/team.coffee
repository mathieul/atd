expect = require('chai').expect
Team = require('../app/team')

describe "Team", ->

  describe "a new instance", ->

    it "has a null name by default", ->
      team = new Team
      expect(team.name).to.be.a 'null'