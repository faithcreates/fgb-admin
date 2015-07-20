assert = require 'power-assert'
{EventService} = require '../../src/services/event-service'

describe 'EventService', ->
  it 'works', (done) ->
    data =
      foo: 123
      bar: 'abc'
    service = EventService.getInstance()
    service.on 'resource-name:event-name', (eventData) ->
      assert.deepEqual eventData, data
      done()
    service.emit 'resource-name:event-name', data
