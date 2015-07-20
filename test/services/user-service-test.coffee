assert = require 'power-assert'
{EventService} = require '../../src/services/event-service'
{UserService} = require '../../src/services/user-service'

describe 'UserService', ->
  beforeEach ->
    @eventService = EventService.getInstance()
    @eventService.removeAllListeners()

  afterEach ->
    @eventService.removeAllListeners()

  it 'works', (done) ->
    user1 =
      slackUsername: 'foo1'
      backlogUsername: 'foo2'
      githubUsername: 'foo3'
    user2 =
      slackUsername: 'bar1'
      backlogUsername: 'bar2'
      githubUsername: 'bar3'
    user3 =
      slackUsername: 'baz1'
      backlogUsername: 'baz2'
      githubUsername: 'baz3'
    service = UserService.getInstance()
    service.addUser user1
    .then ->
      service.addUser user2
    .then ->
      assert.deepEqual service.getUsers(), [user1, user2]
    .then =>
      @eventService.on 'user:changed', ({ users }) ->
        assert.deepEqual users, [user1, user2, user3]
        assert.deepEqual users, service.getUsers()
        done()
      service.addUser user3

  describe '#addUser', ->
    it 'works', ->
      user =
        slackUsername: 'foo1'
        backlogUsername: 'foo2'
        githubUsername: 'foo3'
      service = new UserService()
      service.addUser user

    it 'works', ->
      user =
        slackUsername: null
        backlogUsername: 'foo2'
        githubUsername: 'foo3'
      service = new UserService()
      service.addUser user
      .catch (e) ->
        assert e.message is 'validation error'

    it 'works', ->
      user =
        slackUsername: 'foo1'
        backlogUsername: ''
        githubUsername: 'foo3'
      service = new UserService()
      service.addUser user
      .catch (e) ->
        assert e.message is 'validation error'
