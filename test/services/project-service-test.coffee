assert = require 'power-assert'
request = require 'request'
sinon = require 'sinon'
{EventService} = require '../../src/services/event-service'
{ChannelService} = require '../../src/services/channel-service'
{ProjectService} = require '../../src/services/project-service'

describe 'ProjectService', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @eventService = EventService.getInstance()
    @eventService.removeAllListeners()
    channelService = ChannelService.getInstance()
    @sinon.stub channelService, 'getChannels', ->
      [
        id: '456'
        name: 'channel'
      ]

  afterEach ->
    @sinon.restore()
    @eventService.removeAllListeners()

  describe '#addProject', ->
    beforeEach ->
      @project =
        name: 'foo'
        channel:
          id: '456'
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, statusCode: 201, body:
          id: '123'
          name: @project.name
          channelId: '456'

    it 'works', (done) ->
      @eventService.on 'project:changed', ({ projects }) =>
        assert.deepEqual projects, [
          id: '123'
          name: @project.name
          channel:
            id: '456'
            name: 'channel'
        ]
        assert.deepEqual projects, service.getProjects()
        done()
      service = new ProjectService()
      service.addProject @project

    it 'works', ->
      project =
        name: null
        channel:
          id: '123'
      service = new ProjectService()
      service.addProject project
      .catch (e) ->
        assert e.message is 'validation error'

    it 'works', ->
      project =
        name: ''
        channel:
          id: '123'
      service = new ProjectService()
      service.addProject project
      .catch (e) ->
        assert e.message is 'validation error'

  describe '#deleteProject / #getProjects', ->
    beforeEach ->
      @project =
        name: 'foo'
        channel:
          id: '123'
      callCount = 0
      @sinon.stub request, 'Request', ({ callback }) =>
        callCount += 1
        if callCount is 1
          # addProject
          callback null, statusCode: 201, body:
            id: '123'
            name: @project.name
            channelId: '123'
        else if callCount is 2
          callback null, statusCode: 204 # deleteProject

    it 'works', (done) ->
      service = new ProjectService()
      service.addProject @project
      .then =>
        # before: 1 item
        assert service.getProjects().length is 1
        @eventService.on 'project:changed', ({ projects }) ->
          # after: no item
          assert.deepEqual projects, []
          assert service.getProjects().length is 0
          done()
        service.deleteProject { id: '123' }

  describe '#fetchProjects / #getProjects', ->
    beforeEach ->
      @projects = [
        id: '123'
        name: 'foo'
      ]
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, body: @projects

    it 'works', (done) ->
      service = new ProjectService()
      @eventService.on 'project:changed', ({ projects }) =>
        assert.deepEqual projects, @projects
        assert.deepEqual projects, service.getProjects()
        done()
      service.fetchProjects()
