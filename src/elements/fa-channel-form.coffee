{ChannelService} = require '../services/channel-service'

class Controller
  @$inject: []

  constructor: ->
    @channel = {}

  addChannel: ->
    channelService = ChannelService.getInstance()
    channelService.addChannel @channel
    .then =>
      @channel = {}

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-channel-form.html'
