{ChannelService} = require '../services/channel-service'
{EventService} = require '../services/event-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @channels = []

    eventService = EventService.getInstance()
    eventService.on 'channel:changed', ({ channels }) =>
      @channels = channels
      @$timeout ->

    channelService = ChannelService.getInstance()
    channelService.fetchChannels()

  deleteChannel: (channel) ->
    channelService = ChannelService.getInstance()
    channelService.deleteChannel channel

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-channel-list.html'
