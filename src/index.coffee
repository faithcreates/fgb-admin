require 'angular'

angular
.module 'app', [
  require('./templates').name
]
.directive 'faApp', require './elements/fa-app'
.directive 'faChannelForm', require './elements/fa-channel-form'
.directive 'faChannelList', require './elements/fa-channel-list'
.directive 'faChannelSection', require './elements/fa-channel-section'
.directive 'faProjectForm', require './elements/fa-project-form'
.directive 'faProjectList', require './elements/fa-project-list'
.directive 'faProjectSection', require './elements/fa-project-section'
.directive 'faRepositoryForm', require './elements/fa-repository-form'
.directive 'faRepositoryList', require './elements/fa-repository-list'
.directive 'faRepositorySection', require './elements/fa-repository-section'
.directive 'faUserForm', require './elements/fa-user-form'
.directive 'faUserList', require './elements/fa-user-list'
.directive 'faUserSection', require './elements/fa-user-section'
