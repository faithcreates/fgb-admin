class Controller
  @$inject: []

  constructor: ->
    # FIXME: dummy data
    @users = [
      slackUsername: 'slack-bouzuya'
      backlogUsername: 'backlog-bouzuya'
      githubUsername: 'github-bouzuya'
    ]

module.exports = ->
  bindToController: true
  controller: Controller
  controllerAs: 'c'
  restrict: 'E'
  scope: {}
  templateUrl: '/elements/fa-app.html'
