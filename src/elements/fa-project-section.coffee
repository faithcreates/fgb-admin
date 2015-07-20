class Controller
  @$inject: []

  constructor: ->
    @onProjectAdded = @onProjectAdded.bind @

  onProjectAdded: (project) ->
    @projects.push project

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    projects: '='
  templateUrl: '/elements/fa-project-section.html'
