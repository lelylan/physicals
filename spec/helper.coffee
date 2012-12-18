Physical = require '../app/models/jobs/physical'
Device   = require '../app/models/devices/device'

# Remove all content on the used collections.
exports.cleanDB = ->
  Device.find().remove()
  # Physical.find().remove() # We can not delete records in a capped collection

# Set the physical as processed
exports.clear = (physical) ->
  physical.physical_processed = true; physical.save();
