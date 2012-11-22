settings = require('konphyg')(__dirname + '/../config/settings')('settings');
nock     = require 'nock'
fs       = require 'fs'

helper = require './helper'
logic  = require '../lib/logic'

Event   = require '../app/models/jobs/event'
Device  = require '../app/models/devices/device'
Factory = require 'factory-lady'

require './factories/jobs/event'
require './factories/devices/device'

# Global variables
event = device = request = undefined

# Get back the updated event representation after being processed.
getProcessedEvent = (doc)->
  Device.findById(doc.id, (d) -> console.log "SO, Do i exist?", d)
  console.log "DEBUG", 'created event resource is', doc.resource_id
  console.log "DEBUG", 'created device id', device.id
  setTimeout ( -> Event.findById doc.id, (err, doc) ->  event = doc ), settings.factory_time / 2


describe 'Physical Requests', ->

  logic.execute()

  beforeEach -> helper.cleanDB(); nock.cleanAll()
  beforeEach -> Factory.create 'device', (doc) -> device = doc

  describe 'when there is a device with a physical connection', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(200)

    beforeEach ->
      setTimeout ( ->
        Factory.create 'event', { resource_id: device.id }, (doc) -> getProcessedEvent(doc)
      ), settings.factory_time

    it 'makes an HTTP request to the physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(true); done() ), settings.process_time

    #it 'sets event#physical_processed field as processed', (done) ->
      #console.log "DEBUG", 'second test'
      #setTimeout ( -> expect(event.physical_processed).toBe(true); done() ), settings.process_time


  #describe 'when the event matches more than one subscription', ->

    #beforeEach -> callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)
                                                        #.filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: another_application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: another_application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'makes an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time


  #describe 'when there are no subscriptions', ->

    #beforeEach -> callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'makes an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time


  #describe 'when the event does not match the subscription because of the #resource field', ->

    #beforeEach -> callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id, resource: 'locations' }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'does not make an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time


  #describe 'when the event does not match the subscription because of the #event field', ->

    #beforeEach -> callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id, event: 'create' }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'does not make an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time


  #describe 'when the access token is blocked', ->

    #beforeEach -> callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { revoked_at: Date.now(), resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'does not make an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time


  #describe 'when the resource owner did not subscribe to a third party app', ->

    #beforeEach ->
      #callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'event', { resource_owner_id: another_user._id }, (doc) -> getProcessedEvent(doc)
      #), settings.factory_time

    #it 'does not make an HTTP request to the subscription URI callback', (done) ->
      #setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time

    #it 'sets event#callback_processed field as processed', (done) ->
      #setTimeout ( -> expect(event.callback_processed).toBe(true); done() ), settings.process_time



  #describe 'when the callback does not get a 2xx response', ->

    #beforeEach -> failing_callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(500)
    #beforeEach -> callback         = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

    #beforeEach ->
      #setTimeout ( ->
        #Factory.create 'access_token', { resource_owner_id: user.id, application_id: application.id }, (doc) ->
        #Factory.create 'subscription', { client_id: application.id }, (doc) ->
        #Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->  getProcessedEvent(doc)
      #), settings.factory_time

    #describe 'when making the first HTTP request', ->

      #it 'calls the service returning 500', (done) ->
        #setTimeout ( -> expect(failing_callback.isDone()).toBe(true); helper.clear(event); done() ), settings.process_time

      #it 'leaves the callback_processed field unprocessed', (done) ->
        #setTimeout ( -> expect(event.callback_processed).toBe(false); helper.clear(event); done() ), settings.process_time

    #describe 'when succed making the last attempt', ->

      #it 'calls the service returning 200 OK (1 sec later)', (done) ->
        #setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time + 1000

      #it 'sets event#callback_processed field as processed', (done) ->
        #setTimeout ( -> Event.findById event.id, (err, doc) ->
            #expect(doc.callback_processed).toBe(true); done()
        #), (settings.process_time) + 1000

    #describe 'when fails making the last attempt', ->

      #beforeEach -> nock.cleanAll()
      #beforeEach -> failing_callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(500)
      #beforeEach -> callback         = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(500)

      #it 'calls the service returning 500 (1 sec later)', (done) ->
        #setTimeout ( -> expect(callback.isDone()).toBe(true); helper.clear(event); done() ), settings.process_time + 1000

      #it 'sets event#callback_processed field as processed (no more attempts)', (done) ->
        #setTimeout ( -> Event.findById event.id, (err, doc) ->
            #expect(doc.callback_processed).toBe(true); done()
        #), (settings.process_time) + 1000
