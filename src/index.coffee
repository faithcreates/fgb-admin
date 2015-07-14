require 'angular'

angular
.module 'app', [
  require('./templates').name
]
.directive 'faApp', require './elements/fa-app'
