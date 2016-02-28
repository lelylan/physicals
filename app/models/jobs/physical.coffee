mongoose = require 'mongoose'
db = mongoose.createConnection process.env.MONGOLAB_JOBS_URL

physicalSchema = new mongoose.Schema
  data: mongoose.Schema.Types.Mixed
  resource_id: mongoose.Schema.Types.ObjectId
  physical_processed: { type: Boolean, default: false }

physicalSchema.set
 capped: { size: 1024, max: 1000, autoIndexId: true }

module.exports = db.model 'physical', physicalSchema
