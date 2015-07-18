class Controller
  @$inject: []

  constructor: ->
    @repository = {}

  addRepository: ->
    return unless @_validate @repository
    r = @repository
    @repository = {}
    @onRepositoryAdded r

  _validate: (repository) ->
    return false unless repository?
    return false unless repository.name?.length > 0
    return false unless repository.project?
    true

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    onRepositoryAdded: '='
    projects: '='
  templateUrl: '/elements/fa-repository-form.html'
