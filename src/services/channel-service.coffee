{Promise} = require 'es6-promise'
request = require 'request'
config = require '../configs/config'
{EventService} = require '../services/event-service'

class ChannelService
  @_instance: null

  @getInstance: ->
    @_instance = new ChannelService() unless @_instance?
    @_instance

  constructor: ->
    @_channels = []
    @_baseUrl = config.apiBaseUrl

  addChannel: (channel) ->
    new Promise (resolve, reject) =>
      isValid = @_validate channel
      return reject(new Error('validation error')) unless isValid
      @_request
        method: 'POST'
        url: @_baseUrl + '/channels/'
        form: channel
        json: true
      .then (res) =>
        unless res.statusCode is 201
          throw new Error 'server error'
        @_channels.push
          id: res.body.id
          name: channel.name
        eventService = EventService.getInstance()
        eventService.emit 'channel:changed', channels: @_channels
        null
      .then resolve, reject

  deleteChannel: (channel) ->
    new Promise (resolve, reject) =>
      @_request
        method: 'DELETE'
        url: @_baseUrl + '/channels/' + channel.id
        json: true
      .then (res) =>
        if res.statusCode < 200 and 300 <= res.statusCode
          throw new Error 'server error'
        index = -1
        @_channels.forEach (u, i) ->
          return unless u.id is channel.id
          index = i
        return null if index is -1
        @_channels.splice index, 1
        eventService = EventService.getInstance()
        eventService.emit 'channel:changed', channels: @_channels
        null
      .then resolve, reject

  fetchChannels: ->
    @_request
      method: 'GET'
      url: @_baseUrl + '/channels/'
      json: true
    .then (res) =>
      @_channels = res.body
      eventService = EventService.getInstance()
      eventService.emit 'channel:changed', channels: @_channels
      null

  getChannels: ->
    @_channels.slice()

  _request: (options) ->
    new Promise (resolve, reject) ->
      request options, (err, res) ->
        return reject(err) if err?
        resolve res

  _validate: (channel) ->
    return false unless channel?
    return false unless channel.name?.length > 0
    true

module.exports.ChannelService = ChannelService
