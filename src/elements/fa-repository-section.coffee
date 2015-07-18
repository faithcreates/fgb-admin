class Controller
  @$inject: []

  constructor: ->

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    repositories: '='
  templateUrl: '/elements/fa-repository-section.html'
