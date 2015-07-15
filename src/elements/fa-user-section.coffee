class Controller
  @$inject: []

  constructor: ->
    @onUserAdded = @onUserAdded.bind @

  onUserAdded: (user) ->
    @users.push user

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    users: '='
  templateUrl: '/elements/fa-user-section.html'
