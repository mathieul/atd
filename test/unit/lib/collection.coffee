expect = require('chai').expect
Collection = require('lib/collection')
model = require('lib/model')

class TestModel
  constructor: (attributes) ->
    model.setupFields(this, ['uid', 'name'], attributes)

describe "Collection:", ->
  beforeEach ->
      @collection = new Collection(TestModel)

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

  it "picks the instances matching the equality filters with #pick", ->
    gainsbourg = @collection.create(name: "Gainsbourg")
    bashung = @collection.create(uid: "001", name: "Bashung")
    found = @collection.pick(name: "Bashung")
    expect(found).to.deep.equal [bashung]