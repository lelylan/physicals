settings = require('konphyg')(__dirname + '/../config/settings')('settings')

request  = require 'request'
mongoose = require 'mongoose'
crypto   = require 'crypto'
uuid     = require 'node-uuid'

Event  = require '../app/models/jobs/event'
Device = require '../app/models/devices/device'


exports.execute = ->
  Event.find({ physical_processed: false, source: 'lelylan', event: 'property-updated' })
  .tailable().stream().on('data', (collection) -> start(collection))


start = (event) ->

  # Set a closure to get the access of event between the callbacks
  ( (event) ->

    # Check if the device has a physical connection
    findDevice = (err, device) ->
      console.log "ERROR", err.message if (err)
      condole.log 'DEBUG: device without physical connection' if (!device.physical and process.env.DEBUG)
      sendRequest(device) if (device and device.physical)

    # Send the request to the physical device
    sendRequest = (device) ->
      console.log 'DEBUG: sending request to', device.physical if process.env.DEBUG
      options = { uri: device.physical, method: 'POST', headers: getHeaders(device), json: payload() }

      request options, (err, response, body) ->
        console.log "ERROR", err.message if (err)
        console.log 'DEBUG: request sent to', device.physical if process.env.DEBUG

    # Create the payload to send to the physical device
    payload = () ->
      { nonce: uuid.v4(), properties: event.data.properties }

    # Create the headers to send to the physical device
    getHeaders = (device) ->
      shasum  = crypto.createHmac("sha1", device.secret);
      content = payload(event)
      shasum.update JSON.stringify(content)
      { 'X-Physical-Signature': shasum.digest('hex'), 'accept': 'application/json' }

    # Set the physical_processed field to true
    setPhysicalProcessed = ->
      event.physical_processed = true; event.save()

    # EVERYTHING STARTS HERE ->
    Device.findById(event.resource_id, findDevice)
    setPhysicalProcessed()

  )(event)
