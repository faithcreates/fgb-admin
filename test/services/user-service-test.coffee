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
      @user =
        slackUsername: 'foo1'
        backlogUsername: 'foo2'
        githubUsername: 'foo3'
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, statusCode: 201, body:
          id: '123'
          slackUsername: @user.slackUsername
          backlogUsername: @user.backlogUsername
          githubUsername: @user.githubUsername

    it 'works', (done) ->
      @eventService.on 'user:changed', ({ users }) =>
        assert.deepEqual users, [
          id: '123'
          slackUsername: @user.slackUsername
          backlogUsername: @user.backlogUsername
          githubUsername: @user.githubUsername
        ]
        assert.deepEqual users, service.getUsers()
        done()
      service = new UserService()
      service.addUser @user

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

  describe '#deleteUser / #getUsers', ->
    beforeEach ->
      @user =
        slackUsername: 'hoge1'
        backlogUsername: 'hoge2'
        githubUsername: 'hoge3'
      callCount = 0
      @sinon.stub request, 'Request', ({ callback }) =>
        callCount += 1
        if callCount is 1
          # addUser
          callback null, statusCode: 201, body:
            id: '123'
            slackUsername: @user.slackUsername
            backlogUsername: @user.backlogUsername
            githubUsername: @user.githubUsername
        else if callCount is 2
          callback null, statusCode: 204 # deleteUser

    it 'works', (done) ->
      service = new UserService()
      service.addUser @user
      .then =>
        # before: 1 item
        assert.deepEqual [
          id: '123'
          slackUsername: @user.slackUsername
          backlogUsername: @user.backlogUsername
          githubUsername: @user.githubUsername
        ], service.getUsers()
        @eventService.on 'user:changed', ({ users }) ->
          # after: no item
          assert.deepEqual users, []
          assert.deepEqual users, service.getUsers()
          done()
        service.deleteUser { id: '123' }

  describe '#fetchUsers / #getUsers', ->
    beforeEach ->
      @users = [
        id: '123'
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
