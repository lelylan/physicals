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
event = device = device_no_physical = request = undefined

# Get back the updated event representation after it has been processed.
getProcessedEvent = (doc)->
  setTimeout ( -> Event.findById doc.id, (err, doc) ->  event = doc ), settings.factory_time / 2


describe 'Physical Requests', ->

  logic.execute()

  beforeEach -> helper.cleanDB(); nock.cleanAll()
  beforeEach ->
    Factory.create 'device', (doc) -> device = doc
    Factory.create 'device', { physical: undefined }, (doc) -> device_no_physical = doc


  describe 'when there is a device with a physical connection', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(200)

    beforeEach ->
      setTimeout ( ->
        Factory.create('event', { resource_id: device.id }, (doc) -> getProcessedEvent(doc))
      ), settings.factory_time

    it 'makes an HTTP request to the physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(true); done() ), settings.process_time

    it 'sets event#physical_processed field as processed', (done) ->
      setTimeout ( -> expect(event.physical_processed).toBe(true); done() ), settings.process_time


  describe 'when the updates comes from the physical world', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(200)

    beforeEach ->
      setTimeout ( ->
        Factory.create('event', { source: 'physical' }, (doc) -> getProcessedEvent(doc))
      ), settings.factory_time

    it 'does not make an HTTP request to the physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(false); done() ), settings.process_time

    it 'does not set event#physical_processed field as processed', (done) ->
      setTimeout ( -> expect(event.physical_processed).toBe(false); done() ), settings.process_time


  describe 'when the event is not property-updated', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(200)

    beforeEach ->
      setTimeout ( ->
        Factory.create('event', { resource_id: device.id, event: 'created' }, (doc) -> getProcessedEvent(doc))
      ), settings.factory_time

    it 'does not make an HTTP request to the physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(false); done() ), settings.process_time

    it 'does not set event#physical_processed field as processed', (done) ->
      setTimeout ( -> expect(event.physical_processed).toBe(false); done() ), settings.process_time


  describe 'when the device has not a physical connection', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(200)

    beforeEach ->
      setTimeout ( ->
        Factory.create('event', { resource_id: device_no_physical.id }, (doc) -> getProcessedEvent(doc))
      ), settings.factory_time

    it 'does not make an HTTP request to the not existing physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(false); done() ), settings.process_time

    it 'sets event#physical_processed field as processed', (done) ->
      setTimeout ( -> expect(event.physical_processed).toBe(true); done() ), settings.process_time


  describe 'when the physical device returns an error', ->

    beforeEach -> request = nock('http://arduino.house.com').filteringRequestBody( (path) -> '*' ).post('/5a3c', '*').reply(500)

    beforeEach ->
      setTimeout ( ->
        Factory.create('event', { resource_id: device.id }, (doc) -> getProcessedEvent(doc))
      ), settings.factory_time

    it 'makes an HTTP request to the not existing physical device', (done) ->
      setTimeout ( -> expect(request.isDone()).toBe(true); done() ), settings.process_time

    it 'sets event#physical_processed field as processed', (done) ->
      setTimeout ( -> expect(event.physical_processed).toBe(true); done() ), settings.process_time

