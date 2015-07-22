assert = require 'power-assert'
request = require 'request'
sinon = require 'sinon'
{EventService} = require '../../src/services/event-service'
{ProjectService} = require '../../src/services/project-service'
{RepositoryService} = require '../../src/services/repository-service'

describe 'RepositoryService', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @eventService = EventService.getInstance()
    @eventService.removeAllListeners()
    projectService = ProjectService.getInstance()
    @sinon.stub projectService, 'getProjects', ->
      [
        id: '456'
        name: 'project'
      ]

  afterEach ->
    @sinon.restore()
    @eventService.removeAllListeners()

  describe '#addRepository', ->
    beforeEach ->
      @repository =
        name: 'foo'
        project:
          id: '456'
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, statusCode: 201, body:
          id: '123'
          name: @repository.name
          projectId: '456'

    it 'works', (done) ->
      @eventService.on 'repository:changed', ({ repositories }) =>
        assert.deepEqual repositories, [
          id: '123'
          name: @repository.name
          project:
            id: '456'
            name: 'project'
        ]
        assert.deepEqual repositories, service.getRepositories()
        done()
      service = new RepositoryService()
      service.addRepository @repository

    it 'works', ->
      repository =
        name: null
        project:
          id: '123'
      service = new RepositoryService()
      service.addRepository repository
      .catch (e) ->
        assert e.message is 'validation error'

    it 'works', ->
      repository =
        name: ''
        project:
          id: '123'
      service = new RepositoryService()
      service.addRepository repository
      .catch (e) ->
        assert e.message is 'validation error'

  describe '#deleteRepository / #getRepositories', ->
    beforeEach ->
      @repository =
        name: 'foo'
        project:
          id: '123'
      callCount = 0
      @sinon.stub request, 'Request', ({ callback }) =>
        callCount += 1
        if callCount is 1
          # addRepository
          callback null, statusCode: 201, body:
            id: '123'
            name: @repository.name
            projectId: '123'
        else if callCount is 2
          callback null, statusCode: 204 # deleteRepository

    it 'works', (done) ->
      service = new RepositoryService()
      service.addRepository @repository
      .then =>
        # before: 1 item
        assert service.getRepositories().length is 1
        @eventService.on 'repository:changed', ({ repositories }) ->
          # after: no item
          assert.deepEqual repositories, []
          assert service.getRepositories().length is 0
          done()
        service.deleteRepository { id: '123' }

  describe '#fetchRepositories / #getRepositories', ->
    beforeEach ->
      @repositories = [
        id: '123'
        name: 'foo'
      ]
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, body: @repositories

    it 'works', (done) ->
      service = new RepositoryService()
      @eventService.on 'repository:changed', ({ repositories }) =>
        assert.deepEqual repositories, @repositories
        assert.deepEqual repositories, service.getRepositories()
        done()
      service.fetchRepositories()
