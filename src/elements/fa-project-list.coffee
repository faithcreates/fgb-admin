{EventService} = require '../services/event-service'
{ProjectService} = require '../services/project-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @projects = []

    eventService = EventService.getInstance()
    eventService.on 'project:changed', ({ projects }) =>
      @projects = projects
      @$timeout ->

    projectService = ProjectService.getInstance()
    projectService.fetchProjects()

  deleteUser: (project) ->
    projectService = ProjectService.getInstance()
    projectService.deleteProject project

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-project-list.html'
