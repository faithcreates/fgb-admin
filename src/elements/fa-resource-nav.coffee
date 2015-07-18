class Controller
  @$inject: []

  constructor: ->

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-resource-nav.html'
