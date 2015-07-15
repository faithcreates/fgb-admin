class Controller
  @$inject: []

  constructor: ->
    @user = {}

  addUser: ->
    return unless @_validate @user
    @onUserAdded @user

  _validate: (user) ->
    return false unless user?
    return false unless user.slackUsername?.length > 0
    return false unless user.backlogUsername?.length > 0
    return false unless user.githubUsername?.length > 0
    true

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    onUserAdded: '='
  templateUrl: '/elements/fa-user-form.html'
