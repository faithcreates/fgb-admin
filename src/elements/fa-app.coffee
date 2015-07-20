{ChannelService} = require '../services/channel-service'
{EventService} = require '../services/event-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    # FIXME: dummy data
    @channels = []
    @projects = []
    @repositories = []

    eventService = EventService.getInstance()
    eventService.on 'channel:changed', ({ channels }) =>
      @channels = channels

      # FIXME:
      @projects = [
        name: 'backlog-project'
        channel: @channels[0]
      ]
      @repositories = [
        name: 'github-repository'
        project: @projects[0]
      ]

      @$timeout ->

    channelService = ChannelService.getInstance()
    channelService.fetchChannels()

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-app.html'
