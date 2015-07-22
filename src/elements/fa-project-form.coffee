{ChannelService} = require '../services/channel-service'
{EventService} = require '../services/event-service'
{ProjectService} = require '../services/project-service'

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
    projectService = ProjectService.getInstance()
    projectService.addProject @project
    .then =>
      @project = {}

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-project-form.html'
