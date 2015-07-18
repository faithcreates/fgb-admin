require 'angular'

angular
.module 'app', [
  require('./templates').name
]
.directive 'faApp', require './elements/fa-app'
.directive 'faChannelForm', require './elements/fa-channel-form'
.directive 'faChannelList', require './elements/fa-channel-list'
.directive 'faChannelSection', require './elements/fa-channel-section'
.directive 'faProjectSection', require './elements/fa-project-section'
.directive 'faUserForm', require './elements/fa-user-form'
.directive 'faUserList', require './elements/fa-user-list'
.directive 'faUserSection', require './elements/fa-user-section'
