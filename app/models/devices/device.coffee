mongoose = require 'mongoose'
db = mongoose.createConnection process.env.MONGOLAB_DEVICES_URL

deviceSchema = new mongoose.Schema
  secret: String
  physical: String

module.exports = db.model 'device', deviceSchema
