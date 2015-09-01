{Promise} = require 'es6-promise'
request = require 'request'
{EventService} = require '../services/event-service'
{ProjectService} = require '../services/project-service'

class RepositoryService
  @_instance: null

  @getInstance: ->
    @_instance = new RepositoryService() unless @_instance?
    @_instance

  constructor: ->
    @_repositories = []
    @_baseUrl = process.env.API_BASE_URL

  addRepository: (repository) ->
    new Promise (resolve, reject) =>
      isValid = @_validate repository
      return reject(new Error('validation error')) unless isValid
      @_request
        method: 'POST'
        url: @_baseUrl + '/repositories/'
        form:
          name: repository.name
          projectId: repository.project.id
        json: true
      .then (res) =>
        unless res.statusCode is 201
          throw new Error 'server error'
        projectService = ProjectService.getInstance()
        projects = projectService.getProjects()
        project = projects.filter((i) -> i.id is res.body.projectId)[0]
        @_repositories.push
          id: res.body.id
          name: repository.name
          project: project
        eventService = EventService.getInstance()
        eventService.emit 'repository:changed', repositories: @_repositories
        null
      .then resolve, reject

  deleteRepository: (repository) ->
    new Promise (resolve, reject) =>
      @_request
        method: 'DELETE'
        url: @_baseUrl + '/repositories/' + repository.id
        json: true
      .then (res) =>
        if res.statusCode < 200 and 300 <= res.statusCode
          throw new Error 'server error'
        index = -1
        @_repositories.forEach (u, i) ->
          return unless u.id is repository.id
          index = i
        return null if index is -1
        @_repositories.splice index, 1
        eventService = EventService.getInstance()
        eventService.emit 'repository:changed', repositories: @_repositories
        null
      .then resolve, reject

  fetchRepositories: ->
    @_request
      method: 'GET'
      url: @_baseUrl + '/repositories/'
      json: true
    .then (res) =>
      @_repositories = res.body
      projectService = ProjectService.getInstance()
      projects = projectService.getProjects()
      @_repositories.forEach (i) ->
        i.project = projects.filter((j) -> j.id is i.projectId)[0]
        i.projectId = null
      eventService = EventService.getInstance()
      eventService.emit 'repository:changed', repositories: @_repositories
      null

  getRepositories: ->
    @_repositories.slice()

  _request: (options) ->
    new Promise (resolve, reject) ->
      request options, (err, res) ->
        return reject(err) if err?
        resolve res

  _validate: (repository) ->
    return false unless repository?
    return false unless repository.name?.length > 0
    return false unless repository.project?
    true

module.exports.RepositoryService = RepositoryService
