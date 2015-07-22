{EventService} = require '../services/event-service'
{RepositoryService} = require '../services/repository-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @projects = []

    eventService = EventService.getInstance()
    eventService.on 'repository:changed', ({ repositories }) =>
      @repositories = repositories
      @$timeout ->

    repositoryService = RepositoryService.getInstance()
    repositoryService.fetchRepositories()

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-repository-list.html'
