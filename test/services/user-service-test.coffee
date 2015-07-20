assert = require 'power-assert'
request = require 'request'
sinon = require 'sinon'
{EventService} = require '../../src/services/event-service'
{UserService} = require '../../src/services/user-service'

describe 'UserService', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @eventService = EventService.getInstance()
    @eventService.removeAllListeners()

  afterEach ->
    @sinon.restore()
    @eventService.removeAllListeners()

  describe '#addUser', ->
    beforeEach ->
      @users = [
        slackUsername: 'hoge1'
        backlogUsername: 'hoge2'
        githubUsername: 'hoge3'
      ]
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, statusCode: 201

    it 'works', (done) ->
      user =
        slackUsername: 'foo1'
        backlogUsername: 'foo2'
        githubUsername: 'foo3'
      @eventService.on 'user:changed', ({ users }) ->
        assert.deepEqual users, [user]
        assert.deepEqual users, service.getUsers()
        done()
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

  describe '#fetchUsers / #getUsers', ->
    beforeEach ->
      @users = [
        slackUsername: 'hoge1'
        backlogUsername: 'hoge2'
        githubUsername: 'hoge3'
      ]
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, body: @users

    it 'works', (done) ->
      service = new UserService()
      @eventService.on 'user:changed', ({ users }) =>
        assert.deepEqual users, @users
        assert.deepEqual users, service.getUsers()
        done()
      service.fetchUsers()
