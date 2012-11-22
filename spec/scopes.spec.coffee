# $ foreman run node node_modules/jasmine-node/lib/jasmine-node/cli.js --autotest --coffee spec/scopes.spec.coffee

settings = require('konphyg')(__dirname + '/../config/settings')('settings')
fs       = require 'fs'
mongoose = require 'mongoose'
nock     = require 'nock'

helper = require './helper'
logic  = require '../lib/logic'

Event   = require '../app/models/jobs/event'
Factory = require 'factory-lady'

require './factories/jobs/event'
require './factories/subscriptions/subscription'
require './factories/people/user'
require './factories/people/application'
require './factories/people/access_token'

# Global variables
user = application = event = callback = device_id = undefined;


describe 'AccessToken', ->

  logic.execute()

  beforeEach ->
    helper.cleanDB()
    nock.cleanAll()
    callback = nock('http://callback.com').filteringRequestBody( (path) -> '*' ).post('/lelylan', '*').reply(200)

  beforeEach ->
    Factory.create 'user', (doc) -> user = doc
    Factory.create 'application', (doc) -> application = doc


  describe 'when the access token lets the client access to all owned resources', ->

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { scopes: 'resources-read', resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time


  describe 'when the access token lets the client access to desired resource type', ->

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { scopes: 'devices-read', resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time


  describe 'when the access token does not let the client access to desired resource type', ->

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { scopes: 'location-read', resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time


  describe 'when the access token does not filter any device id', ->

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { device_ids: [], resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time


  describe 'when the access token filters the notified resource', ->

    beforeEach -> device_id = mongoose.Types.ObjectId '5003c60ed033a96b96000009'

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { device_ids: [device_id], resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(true); done() ), settings.process_time


  describe 'when the access token does not let the access to the notified resource', ->

    beforeEach -> device_id = mongoose.Types.ObjectId '5003c60ed033a96b96000008'

    beforeEach ->
      setTimeout ( ->
        Factory.create 'access_token', { device_ids: [device_id], resource_owner_id: user.id, application_id: application.id }, (doc) ->
        Factory.create 'subscription', { client_id: application.id }, (doc) ->
        Factory.create 'event',        { resource_owner_id: user._id }, (doc) ->
      ), settings.factory_time

    it 'makes an HTTP request to the subscription URI callback', (done) ->
      setTimeout ( -> expect(callback.isDone()).toBe(false); done() ), settings.process_time
