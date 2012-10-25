expect = require('chai').expect
Team = require('team')

describe "Team", ->

  it "has an id", ->
    team = new Team(id: "abc")
    expect(team.get('id')).to.equal "abc"
    expect(team.id).to.equal "abc"

  it "has a name", ->
    team = new Team(name: "John Zorn")
    expect(team.get('name')).to.equal "John Zorn"
