class Controller
  @$inject: []

  constructor: ->
    @onRepositoryAdded = @onRepositoryAdded.bind @

  onRepositoryAdded: (repository) ->
    @repositories.push repository

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    projects: '='
    repositories: '='
  templateUrl: '/elements/fa-repository-section.html'
