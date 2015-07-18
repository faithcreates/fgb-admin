class Controller
  @$inject: []

  constructor: ->
    # FIXME: dummy data

    @channels = [
      name: 'slack-channel'
    ]

    @projects = [
      name: 'backlog-project'
      channel: @channels[0]
    ]

    @repositories = [
      name: 'github-repository'
      project: @projects[0]
    ]

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
