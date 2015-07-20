{UserService} = require '../services/user-service'

class Controller
  @$inject: []

  constructor: ->
    @user = {}

  addUser: ->
    userService = UserService.getInstance()
    userService.addUser @user
    .then =>
      @user = {}

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-user-form.html'
