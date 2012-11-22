mongoose = require 'mongoose'

Factory = require 'factory-lady'
Device  = require '../../../app/models/devices/device'

Factory.define 'device', Device,
  physical: 'http://arduino.house.com/5a3c'
