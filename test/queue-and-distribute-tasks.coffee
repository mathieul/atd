expect = require('chai').expect
Team = require('team')

describe "Basic Queueing", ->

	beforeEach ->
    @team = new Team(name: "Wedding")
    @mate = @team.createTeammate(name: "Bride", uid: "a1")
    @queue = @team.createQueue(name: "Thank you notes", uid: "e7b")
    @queue.assignTeammate(@mate, level: 1, enabled: true)

  it "assigns a task to a team mate", ->
    @mate.signIn()
    expect(@mate.status()).to.be "on-break"
    @mate.makeAvailable()
    expect(@mate.status()).to.be "waiting"

    state = {}
    @queue
      .on("offer-task",    (t, m) -> state = {status: "offer-task", task: t, teammate: m})
      .on("assign-task",   (t, m) -> state = {status: "assign-task", task: t, teammate: m})
      .on("complete-task", (t, m) -> state = {status: "complete-task", task: t, teammate: m})

    task = new Task(title: "thank Jones family")
    expect(task.isCompleted()).to.be false

    @queue.enqueue(task)
    expect(@queue.tasks()).to.equal [task]
    expect(state).to.deep.equal
      status: "offer-task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.be "task-offered"

    @mate.accept(task)
    expect(state).to.deep.equal
      status: "assign-task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.be "busy"
    expect(@mate.currentTasks()).to.equal [task]

    @mate.complete(task)
    expect(state).to.deep.equal
      status: "complete-task"
      task: task
      teammate: @mate
    expect(@mate.status()).to.be "wrapping-up"
    expect(@mate.currentTasks()).to.equal []
    expect(@queue.tasks()).to.equal []
    expect(task.isCompleted()).to.be true

    @mate.startOtherWork()
    expect(@mate.status()).to.be "other-work"
    @mate.goOnBreak()
    expect(@mate.status()).to.be "break"
    @mate.signOut()
    expect(@mate.status()).to.be "signed-out"
