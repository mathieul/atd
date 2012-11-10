_ = require('underscore')
expect = require('chai').expect
Team = require('models/team')
Task = require('models/task')

describe "Basic Queueing:", ->

  beforeEach ->
    @team = new Team(name: "Wedding", uid: "ba94")
    @mate = @team.teammates().create(name: "Bride", uid: "a1")
    @queue = @team.queues().create(name: "Thank you notes", uid: "e7b")
    @distributor = @team.distributor()

  it "assigns a task to a team mate", (done) ->
    @queue.assignTeammate(@mate, level: "high", enabled: true)
    expect(@mate.queues()).to.deep.equal [@queue]

    @mate.signIn()
    expect(@mate.status()).to.equal "on_break"

    state = null
    setState = (s, t, q, m) -> state = {status: s, task: t, queue: q, teammate: m}
    @distributor
      .on("offer_task",    (t, q, m) -> setState("offer_task", t, q, m))
      .on("assign_task",   (t, q, m) -> setState("assign_task", t, q, m))
      .on("complete_task", (t, q, m) -> setState("complete_task", t, q, m))

    task = new Task(title: "thank Jones family")
    expect(task.status()).to.equal 'created'
    @queue.enqueue(task)
    expect(task.status()).to.equal 'queued'
    expect(@queue.tasks()).to.deep.equal [task]

    @mate.makeAvailable()

    setTimeout =>
      expect(@mate.status()).to.equal "task_offered"
      expect(@mate.currentTask()).to.deep.equal task
      expect(task.status()).to.equal "offered"

      expect(state.status).to.equal "offer_task"
      expect(state.task).to.deep.equal task
      expect(state.queue).to.deep.equal @queue
      expect(state.teammate).to.deep.equal @mate

      @mate.acceptTaskOffered()
      setTimeout =>
        expect(@mate.status()).to.equal "busy"
        expect(@mate.currentTask()).to.deep.equal task
        expect(task.status()).to.equal "assigned"

        expect(state.status).to.equal "assign_task"
        expect(state.task).to.deep.equal task
        expect(state.queue).to.deep.equal @queue
        expect(state.teammate).to.deep.equal @mate

        @mate.finishTask(task)
        setTimeout =>
          expect(@mate.status()).to.equal "wrapping_up"
          expect(@mate.currentTask()).to.be.null
          expect(task.status()).to.equal "completed"
          expect(@queue.tasks()).to.deep.equal []

          expect(state.status).to.equal "complete_task"
          expect(state.task).to.deep.equal task
          expect(state.queue).to.deep.equal @queue
          expect(state.teammate).to.deep.equal @mate

          @mate.startOtherWork()
          expect(@mate.status()).to.equal "other_work"
          @mate.goOnBreak()
          expect(@mate.status()).to.equal "on_break"
          @mate.signOut()
          expect(@mate.status()).to.equal "signed_out"

          done()
        , 1
      , 1
    , 1
