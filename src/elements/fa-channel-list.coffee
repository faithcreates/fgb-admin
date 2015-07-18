class Controller
  @$inject: []

  constructor: ->

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    channels: '='
  templateUrl: '/elements/fa-channel-list.html'
