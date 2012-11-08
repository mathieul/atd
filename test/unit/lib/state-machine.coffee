expect = require('chai').expect
StateMachine = require('lib/state-machine')

config =
  initial: 'created'
  states: [
    'queued'
    'offered'
    'assigned'
    'completed'
    'cancelled'
  ]
  transitions:
    queue:
      from: 'created'
      to: 'queued'
    offer:
      from: 'queued'
      to: 'offered'
    assign:
      from: ['queued', 'offered']
      to: 'assigned'
    complete:
      from: 'assigned'
      to: 'completed'
    cancel:
      from: ['queued', 'offered']
      to: 'cancelled'

describe "StateMachine:", ->
  beforeEach -> @machine = new StateMachine(config)

  it "returns the list of states with #states", ->
    states = @machine.states().sort()
    expected = ['created', 'queued', 'offered', 'assigned', 'completed', 'cancelled'].sort()
    expect(states).to.deep.equal expected

  it "starts with the initial state", ->
    expect(@machine.state()).to.equal 'created'

  describe "#trigger -", ->
    it "transitions to a new state when current state matches", ->
      expect(@machine.state()).to.equal 'created'
      expect(@machine.trigger("queue")).to.be.true
      expect(@machine.state()).to.equal 'queued'

    it "can specify more than one source state allowed for a transition", ->
      @machine.trigger('queue')
      @machine.trigger('offer')
      expect(@machine.trigger("assign")).to.be.true
      expect(@machine.state()).to.equal 'assigned'

    it "doesn't change state when transitioning from the wrong state", ->
      expect(@machine.trigger("assign")).to.be.false
      expect(@machine.state()).to.equal 'created'

  describe "hooks -", ->
    it "can specify a hook to run after the state changes", (done) ->
      machine = new StateMachine config,
        changed: (newState, previousState, message) ->
          expect(newState).to.equal 'queued'
          expect(previousState).to.equal 'created'
          expect(message).to.equal 'queue'
          done()
      machine.trigger('queue')
