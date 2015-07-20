{ChannelService} = require '../services/channel-service'
{EventService} = require '../services/event-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @project = {}
    @channels = []

    eventService = EventService.getInstance()
    eventService.on 'channel:changed', ({ channels }) =>
      @channels = channels
      @$timeout ->

    channelService = ChannelService.getInstance()
    channelService.fetchChannels()

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
    onProjectAdded: '='
  templateUrl: '/elements/fa-project-form.html'
