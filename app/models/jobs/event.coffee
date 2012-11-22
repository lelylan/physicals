mongoose = require 'mongoose'
db = mongoose.createConnection process.env.MONGOLAB_JOBS_URL

eventSchema = new mongoose.Schema
  resource_owner_id: mongoose.Schema.Types.ObjectId
  resource_id: mongoose.Schema.Types.ObjectId
  resource: String
  event: String
  source: String
  data: mongoose.Schema.Types.Mixed
  physical_processed: { type: Boolean, default: false }

module.exports = db.model 'event', eventSchema
