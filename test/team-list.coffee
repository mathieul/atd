expect = require('chai').expect
Team = require('team')
TeamList = require('team-list')

describe "TeamList", ->
  beforeEach ->
    @list = new TeamList

  it "can add a team", ->
    team = new Team
    @list.add(team)
    expect(@list.length).to.equal 1
    expect(@list.toArray()).to.deep.equal [team]

  it "can get a team by id", ->
    team = new Team(id: '007')
    @list.add(team)
    result = @list.get('007')
    expect(result).to.equal(team)