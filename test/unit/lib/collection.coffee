expect = require('chai').expect
EventEmitter2 = require('eventemitter2').EventEmitter2
Collection = require('lib/collection')
model = require('lib/model')

class TestModel
  constructor: (attributes) ->
    model.setupFields(this, ['uid', 'name'], attributes)
    @emitter = new EventEmitter2

  on: (args...) -> @emitter.on(args...)

describe "Collection:", ->
  beforeEach ->
      @collection = new Collection(TestModel)

  describe "manage instances -", ->
    it "creates a new instance of a model", ->
      instance = @collection.create(name: "Bashung")
      expect(instance).to.be.an.instanceof TestModel
      expect(instance.name()).to.equal "Bashung"

    it "retrieves an intance by uid with #get", ->
      gainsbourg = @collection.create(name: "Gainsbourg")
      bashung = @collection.create(name: "Bashung")
      expect(@collection.get(gainsbourg.uid())).to.deep.equal gainsbourg
      expect(@collection.get("abc")).to.be.undefined

    it "keeps track of its number of instances in #length", ->
      expect(@collection.length).to.equal 0
      @collection.create(name: "allo")
      @collection.create(name: "la")
      @collection.create(name: "terre")
      expect(@collection.length).to.equal 3

    it "removes an instance with #remove", ->
      gainsbourg = @collection.create(name: "Gainsbourg")
      bashung = @collection.create(uid: "001", name: "Bashung")
      @collection.remove(gainsbourg)
      expect(@collection.length).to.equal 1
      @collection.remove("001")
      expect(@collection.length).to.equal 0

  describe "query instances -", ->
    it "picks the instances matching the equality filters with #pick", ->
      gainsbourg = @collection.create(name: "Gainsbourg")
      bashung = @collection.create(uid: "001", name: "Bashung")
      found = @collection.pick(name: "Bashung")
      expect(found).to.deep.equal [bashung]

  describe "optional features -", ->
    it "can listen to events on the instances with #on", (done) ->
      collection = new Collection(TestModel, events: ['new-album'])
      gainsbourg = collection.create(name: "Gainsbourg")
      collection.on "new-album", (artist, album) ->
        expect(artist).to.deep.equal(gainsbourg)
        expect(album).to.equal "Aux Armes Etc..."
        done()
      gainsbourg.emitter.emit('discarded')
      gainsbourg.emitter.emit('new-album', gainsbourg, "Aux Armes Etc...")

    it "can set an owner to instances added", ->
      class TestOwner
        collection: -> @_collection ?= new Collection(TestModel, owner: {parent: this})
      owner = new TestOwner(uid: "tst")
      biolay = owner.collection().create(name: "Biolay")
      expect(biolay.parent).to.deep.equal owner
