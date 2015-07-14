require 'angular'

angular
.module 'app', [
  require('./templates').name
]
.directive 'faApp', require './elements/fa-app'
.directive 'faUserList', require './elements/fa-user-list'
.directive 'faUserSection', require './elements/fa-user-section'
