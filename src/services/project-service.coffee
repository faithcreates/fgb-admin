{Promise} = require 'es6-promise'
request = require 'request'
{ChannelService} = require '../services/channel-service'
{EventService} = require '../services/event-service'

class ProjectService
  @_instance: null

  @getInstance: ->
    @_instance = new ProjectService() unless @_instance?
    @_instance

  constructor: ->
    @_projects = []
    @_baseUrl = 'http://localhost:3000'

  addProject: (project) ->
    new Promise (resolve, reject) =>
      isValid = @_validate project
      return reject(new Error('validation error')) unless isValid
      @_request
        method: 'POST'
        url: @_baseUrl + '/projects/'
        form:
          name: project.name
          channelId: project.channel.id
        json: true
      .then (res) =>
        unless res.statusCode is 201
          throw new Error 'server error'
        channelService = ChannelService.getInstance()
        channels = channelService.getChannels()
        channel = channels.filter((i) -> i.id is res.body.channelId)[0]
        @_projects.push
          id: res.body.id
          name: project.name
          channel: channel
        eventService = EventService.getInstance()
        eventService.emit 'project:changed', projects: @_projects
        null
      .then resolve, reject

  deleteProject: (project) ->
    new Promise (resolve, reject) =>
      @_request
        method: 'DELETE'
        url: @_baseUrl + '/projects/' + project.id
        json: true
      .then (res) =>
        if res.statusCode < 200 and 300 <= res.statusCode
          throw new Error 'server error'
        index = -1
        @_projects.forEach (u, i) ->
          return unless u.id is project.id
          index = i
        return null if index is -1
        @_projects.splice index, 1
        eventService = EventService.getInstance()
        eventService.emit 'project:changed', projects: @_projects
        null
      .then resolve, reject

  fetchProjects: ->
    @_request
      method: 'GET'
      url: @_baseUrl + '/projects/'
      json: true
    .then (res) =>
      @_projects = res.body
      eventService = EventService.getInstance()
      eventService.emit 'project:changed', projects: @_projects
      null

  getProjects: ->
    @_projects.slice()

  _request: (options) ->
    new Promise (resolve, reject) ->
      request options, (err, res) ->
        return reject(err) if err?
        resolve res

  _validate: (project) ->
    return false unless project?
    return false unless project.name?.length > 0
    return false unless project.channel?
    true

module.exports.ProjectService = ProjectService
