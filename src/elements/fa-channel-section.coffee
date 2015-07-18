class Controller
  @$inject: []

  constructor: ->
    @onChannelAdded = @onChannelAdded.bind @

  onChannelAdded: (channel) ->
    @channels.push channel

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    channels: '='
  templateUrl: '/elements/fa-channel-section.html'
