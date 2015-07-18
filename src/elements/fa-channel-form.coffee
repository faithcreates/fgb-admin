class Controller
  @$inject: []

  constructor: ->
    @channel = {}

  addChannel: ->
    return unless @_validate @channel
    c = @channel
    @channel = {}
    @onChannelAdded c

  _validate: (user) ->
    return false unless user?
    return false unless user.name?.length > 0
    true

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope:
    onChannelAdded: '='
  templateUrl: '/elements/fa-channel-form.html'
