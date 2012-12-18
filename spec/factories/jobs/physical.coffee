mongoose = require 'mongoose'

Factory  = require 'factory-lady'
Physical = require '../../../app/models/jobs/physical'

Factory.define 'physical', Physical,
  resource_id: mongoose.Types.ObjectId '5003c60ed033a96b96000009'
  data:
    properties:
      uri: 'http://api.lelylan.com/properties/5003c60ed033a96b96000006'
      id: '5003c60ed033a96b96000006'
      value: 'on'
      expected_value: 'on'
