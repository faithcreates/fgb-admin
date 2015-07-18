class Controller
  @$inject: []

  constructor: ->
    @project = {}

  addProject: ->
    return unless @_validate @project
    p = @project
    @project = {}
    @onProjectAdded p

  _validate: (project) ->
    return false unless project?
    return false unless project.name?.length > 0
    return false unless project.channel?
    true

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    channels: '='
    onProjectAdded: '='
  templateUrl: '/elements/fa-project-form.html'
