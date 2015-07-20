{Promise} = require 'es6-promise'
request = require 'request'
{EventService} = require '../services/event-service'

class UserService
  @_instance: null

  @getInstance: ->
    @_instance = new UserService() unless @_instance?
    @_instance

  constructor: ->
    @_users = []

  addUser: (user) ->
    new Promise (resolve, reject) =>
      isValid = @_validate user
      return reject(new Error('validation error')) unless isValid
      @_users.push user

  fetchUsers: ->
    @_request
      url: 'http://localhost:3000/users/'
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
