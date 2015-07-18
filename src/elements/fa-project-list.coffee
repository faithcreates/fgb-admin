class Controller
  @$inject: []

  constructor: ->

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    projects: '='
  templateUrl: '/elements/fa-project-list.html'
