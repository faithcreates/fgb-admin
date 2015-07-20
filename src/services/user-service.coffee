{Promise} = require 'es6-promise'
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
      eventService = EventService.getInstance()
      eventService.emit 'user:changed', users: @_users
      resolve null

  fetch: ->
    setTimeout =>
      @_users = [
        slackUsername: 'slack-bouzuya'
        backlogUsername: 'backlog-bouzuya'
        githubUsername: 'github-bouzuya'
      ]
      eventService = EventService.getInstance()
      eventService.emit 'user:changed', users: @_users
    , 0
    null

  getUsers: ->
    @_users.slice()

  _validate: (user) ->
    return false unless user?
    return false unless user.slackUsername?.length > 0
    return false unless user.backlogUsername?.length > 0
    return false unless user.githubUsername?.length > 0
    true

module.exports.UserService = UserService
