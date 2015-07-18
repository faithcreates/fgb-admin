require 'angular'

angular
.module 'app', [
  require('./templates').name
]
.directive 'faApp', require './elements/fa-app'
.directive 'faChannelSection', require './elements/fa-channel-section'
.directive 'faUserForm', require './elements/fa-user-form'
.directive 'faUserList', require './elements/fa-user-list'
.directive 'faUserSection', require './elements/fa-user-section'
