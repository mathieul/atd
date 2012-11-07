expect = require('chai').expect
Teammate = require('models/teammate')

describe "Teammate:", ->

  describe "attributes -", ->
    it "has a name", ->
      mate = new Teammate(name: "John Zorn")
      expect(mate.name()).to.equal "John Zorn"

  describe "status management -", ->
    beforeEach ->
      @mate = new Teammate(name: "Joey Baron")

    it "has a status 'signed_out' when not signed in", ->
      expect(@mate.status()).to.equal 'signed_out'

    it "can sign in", ->
      @mate.signIn()
      expect(@mate.status()).to.equal 'on_break'

    it "can become available", ->
      @mate.makeAvailable()
      expect(@mate.status()).to.equal 'signed_out'

      @mate.signIn().makeAvailable()
      expect(@mate.status()).to.equal 'waiting'
