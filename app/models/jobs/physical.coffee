mongoose = require 'mongoose'
db = mongoose.createConnection process.env.MONGOLAB_JOBS_URL

physicalSchema = new mongoose.Schema
  data: mongoose.Schema.Types.Mixed
  resource_id: mongoose.Schema.Types.ObjectId
  physical_processed: { type: Boolean, default: false }

module.exports = db.model 'physical', physicalSchema
