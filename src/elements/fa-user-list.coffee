{EventService} = require '../services/event-service'
{UserService} = require '../services/user-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @users = []

    eventService = EventService.getInstance()
    eventService.on 'user:changed', ({ users }) =>
      @users = users
      @$timeout ->

    userService = UserService.getInstance()
    userService.fetchUsers()

  deleteUser: (user) ->
    userService = UserService.getInstance()
    userService.deleteUser user

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-user-list.html'
