{EventService} = require '../services/event-service'

class UserService
  @_instance: null

  @getInstance: ->
    @_instance = new UserService() unless @_instance?
    @_instance

  constructor: ->
    @_users = []

  addUser: (user) ->
    @_users.push user
    eventService = EventService.getInstance()
    eventService.emit 'user:changed', users: @_users
    null

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

module.exports.UserService = UserService
