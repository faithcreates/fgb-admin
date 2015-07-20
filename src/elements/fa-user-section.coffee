{EventService} = require '../services/event-service'
{UserService} = require '../services/user-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    @onUserAdded = @onUserAdded.bind @

    eventService = EventService.getInstance()
    eventService.on 'user:changed', ({ users }) =>
      @users = users
      @$timeout ->

    userService = UserService.getInstance()
    userService.fetch()

  onUserAdded: (user) ->
    userService = UserService.getInstance()
    userService.addUser user

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-user-section.html'
