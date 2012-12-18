settings = require('konphyg')(__dirname + '/../config/settings')('settings')

request  = require 'request'
mongoose = require 'mongoose'
crypto   = require 'crypto'
uuid     = require 'node-uuid'

Physical = require '../app/models/jobs/physical'
Device   = require '../app/models/devices/device'


exports.execute = ->
  Physical.find({ physical_processed: false})
  .tailable().stream().on('data', (collection) -> start(collection))


start = (physical) ->

  # Set a closure to get the access of physical between the callbacks
  ( (physical) ->

    # Check if the device has a physical connection
    findDevice = (err, device) ->
      console.log "ERROR", err.message if (err)
      console.log 'DEBUG: device without physical connection' if (device and !device.physical and process.env.DEBUG)
      sendRequest(device) if (device and device.physical)

    # Send the request to the physical device
    sendRequest = (device) ->
      console.log 'DEBUG: sending request to', device.physical if process.env.DEBUG
      options = { uri: device.physical, method: 'PUT', headers: getHeaders(device), json: payload() }

      request options, (err, response, body) ->
        console.log "ERROR", err.message if (err)
        console.log 'DEBUG: request sent to', device.physical if process.env.DEBUG

    # Create the payload to send to the physical device
    payload = () ->
      { nonce: uuid.v4(), properties: physical.data.properties }

    # Create the headers to send to the physical device
    getHeaders = (device) ->
      shasum  = crypto.createHmac("sha1", device.secret);
      content = payload(physical)
      shasum.update JSON.stringify(content)
      { 'X-Physical-Signature': shasum.digest('hex'), 'Content-Type': 'application/json' }

    # Set the physical_processed field to true
    setPhysicalProcessed = ->
      physical.physical_processed = true; physical.save()

    # EVERYTHING STARTS HERE ->
    console.log 'DEBUG: fetching new physical request' if process.env.DEBUG
    Device.findById(physical.resource_id, findDevice)
    setPhysicalProcessed()

  )(physical)
