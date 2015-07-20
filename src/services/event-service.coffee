{EventEmitter} = require 'events'

class EventService extends EventEmitter
  @_instance: null

  @getInstance: ->
    @_instance = new EventService() unless @_instance?
    @_instance

module.exports.EventService = EventService
