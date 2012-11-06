expect = require('chai').expect
Team = require('models/team')

describe "Basic Queueing", ->

  beforeEach ->
    @team = new Team(name: "Wedding", uid: "ba94")
    @mate = @team.createTeammate(name: "Bride", uid: "a1")
    @queue = @team.createQueue(name: "Thank you notes", uid: "e7b")
    @queue.assignTeammate(@mate, level: "high", enabled: true)

  it "assigns a task to a team mate", ->
    @mate.signIn()
    expect(@mate.status()).to.equal "on_break"
    @mate.makeAvailable()
    expect(@mate.status()).to.equal "waiting"

    state = {}
    @queue
      .on("offer_task",    (t, m) -> state = {status: "offer_task", task: t, teammate: m})
      .on("assign_task",   (t, m) -> state = {status: "assign_task", task: t, teammate: m})
      .on("complete_task", (t, m) -> state = {status: "complete_task", task: t, teammate: m})

    task = new Task(title: "thank Jones family")
    expect(task.completed()).to.be.false

    @queue.enqueue(task)
    expect(@queue.tasks()).to.equal [task]
    expect(state).to.deep.equal
      status: "offer_task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.equal "task_offered"

    @mate.accept(task)
    expect(state).to.deep.equal
      status: "assign_task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.equal "busy"
    expect(@mate.currentTasks()).to.equal [task]

    @mate.complete(task)
    expect(state).to.deep.equal
      status: "complete_task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.equal "wrapping_up"
    expect(@mate.currentTasks()).to.equal []
    expect(@queue.tasks()).to.equal []
    expect(task.completed()).to.be.true

    @mate.startOtherWork()
    expect(@mate.status()).to.equal "other_work"
    @mate.goOnBreak()
    expect(@mate.status()).to.equal "on_break"
    @mate.signOut()
    expect(@mate.status()).to.equal "signed_out"
