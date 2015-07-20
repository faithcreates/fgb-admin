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
      githubUsername: 'foo2'
      backlogUsername: 'foo3'
    user2 =
      slackUsername: 'bar1'
      githubUsername: 'bar2'
      backlogUsername: 'bar3'
    user3 =
      slackUsername: 'baz1'
      githubUsername: 'baz2'
      backlogUsername: 'baz3'
    service = UserService.getInstance()
    service.addUser user1
    service.addUser user2
    assert.deepEqual service.getUsers(), [user1, user2]
    @eventService.on 'user:changed', ({ users }) ->
      assert.deepEqual users, [user1, user2, user3]
      done()
    service.addUser user3
