{EventService} = require '../services/event-service'
{ProjectService} = require '../services/project-service'
{RepositoryService} = require '../services/repository-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @repository = {}
    @projects = []

    eventService = EventService.getInstance()
    eventService.on 'project:changed', ({ projects }) =>
      @projects = projects
      @$timeout ->

    projectService = ProjectService.getInstance()
    projectService.fetchProjects()

  addRepository: ->
    repositoryService = RepositoryService.getInstance()
    repositoryService.addRepository @repository
    .then =>
      @repository

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-repository-form.html'
