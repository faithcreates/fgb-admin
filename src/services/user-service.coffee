{Promise} = require 'es6-promise'
request = require 'request'
config = require '../configs/config'
{EventService} = require '../services/event-service'

class UserService
  @_instance: null

  @getInstance: ->
    @_instance = new UserService() unless @_instance?
    @_instance

  constructor: ->
    @_users = []
    @_baseUrl = config.apiBaseUrl

  addUser: (user) ->
    new Promise (resolve, reject) =>
      isValid = @_validate user
      return reject(new Error('validation error')) unless isValid
      @_request
        method: 'POST'
        url: @_baseUrl + '/users/'
        form: user
        json: true
      .then (res) =>
        unless res.statusCode is 201
          throw new Error 'server error'
        user.id = res.body.id
        @_users.push
          id: res.body.id
          slackUsername: user.slackUsername
          backlogUsername: user.backlogUsername
          githubUsername: user.githubUsername
        eventService = EventService.getInstance()
        eventService.emit 'user:changed', users: @_users
        null
      .then resolve, reject

  deleteUser: (user) ->
    new Promise (resolve, reject) =>
      @_request
        method: 'DELETE'
        url: @_baseUrl + '/users/' + user.id
        json: true
      .then (res) =>
        if res.statusCode < 200 and 300 <= res.statusCode
          throw new Error 'server error'
        index = -1
        @_users.forEach (u, i) ->
          return unless u.id is user.id
          index = i
        return null if index is -1
        @_users.splice index, 1
        eventService = EventService.getInstance()
        eventService.emit 'user:changed', users: @_users
        null
      .then resolve, reject

  fetchUsers: ->
    @_request
      method: 'GET'
      url: @_baseUrl + '/users/'
      json: true
    .then (res) =>
      @_users = res.body
      eventService = EventService.getInstance()
      eventService.emit 'user:changed', users: @_users
      null

  getUsers: ->
    @_users.slice()

  _request: (options) ->
    new Promise (resolve, reject) ->
      request options, (err, res) ->
        return reject(err) if err?
        resolve res

  _validate: (user) ->
    return false unless user?
    return false unless user.slackUsername?.length > 0
    return false unless user.backlogUsername?.length > 0
    return false unless user.githubUsername?.length > 0
    true

module.exports.UserService = UserService
