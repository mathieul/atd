expect    = require('chai').expect
Team      = require 'team'
TeamList  = require 'team-list'
Store     = require 'store'

describe "Store", ->
  beforeEach ->
    @store = new Store

  it "can add and retrieve a team", ->
    team = new Team(id: '001')
    @store.add(team: team)
    result = @store.get(team: '001')
    expect(result).to.equal team
