assert = require 'power-assert'
request = require 'request'
sinon = require 'sinon'
{EventService} = require '../../src/services/event-service'
{ChannelService} = require '../../src/services/channel-service'

describe 'ChannelService', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @eventService = EventService.getInstance()
    @eventService.removeAllListeners()

  afterEach ->
    @sinon.restore()
    @eventService.removeAllListeners()

  describe '#addChannel', ->
    beforeEach ->
      @channel =
        name: 'foo'
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, statusCode: 201, body:
          id: '123'
          name: @channel.name

    it 'works', (done) ->
      @eventService.on 'channel:changed', ({ channels }) =>
        assert.deepEqual channels, [
          id: '123'
          name: @channel.name
        ]
        assert.deepEqual channels, service.getChannels()
        done()
      service = new ChannelService()
      service.addChannel @channel

    it 'works', ->
      channel =
        name: null
      service = new ChannelService()
      service.addChannel channel
      .catch (e) ->
        assert e.message is 'validation error'

    it 'works', ->
      channel =
        name: ''
      service = new ChannelService()
      service.addChannel channel
      .catch (e) ->
        assert e.message is 'validation error'

  describe '#deleteChannel / #getChannels', ->
    beforeEach ->
      @channel =
        name: 'foo'
      callCount = 0
      @sinon.stub request, 'Request', ({ callback }) =>
        callCount += 1
        if callCount is 1
          # addChannel
          callback null, statusCode: 201, body:
            id: '123'
            name: @channel.name
        else if callCount is 2
          callback null, statusCode: 204 # deleteChannel

    it 'works', (done) ->
      service = new ChannelService()
      service.addChannel @channel
      .then =>
        # before: 1 item
        assert.deepEqual [
          id: '123'
          name: @channel.name
        ], service.getChannels()
        @eventService.on 'channel:changed', ({ channels }) ->
          # after: no item
          assert.deepEqual channels, []
          assert.deepEqual channels, service.getChannels()
          done()
        service.deleteChannel { id: '123' }

  describe '#fetchChannels / #getChannels', ->
    beforeEach ->
      @channels = [
        id: '123'
        name: 'foo'
      ]
      @sinon.stub request, 'Request', ({ callback }) =>
        callback null, body: @channels

    it 'works', (done) ->
      service = new ChannelService()
      @eventService.on 'channel:changed', ({ channels }) =>
        assert.deepEqual channels, @channels
        assert.deepEqual channels, service.getChannels()
        done()
      service.fetchChannels()
