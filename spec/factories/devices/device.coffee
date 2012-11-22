mongoose = require 'mongoose'

Factory = require 'factory-lady'
Device  = require '../../../app/models/devices/device'

Factory.define 'device', Device,
  physical: 'http://arduino.house.com/5a3c'
  secret: '0ca70cc411e9e9de25b47b3e76b8a1932ae48bee6e6fa8808b534994dff5045d'
