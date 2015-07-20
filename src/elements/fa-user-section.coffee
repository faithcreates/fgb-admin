{EventService} = require '../services/event-service'
{UserService} = require '../services/user-service'

class Controller
  @$inject: [
    '$timeout'
  ]

  constructor: (@$timeout) ->
    eventService = EventService.getInstance()
    eventService.on 'user:changed', ({ users }) =>
      @users = users
      @$timeout ->

    userService = UserService.getInstance()
    userService.fetch()

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-user-section.html'
