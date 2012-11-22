Event  = require '../app/models/jobs/event'
Device = require '../app/models/devices/device'

# Remove all content on the used collections.
exports.cleanDB = ->
  Device.find().remove()
  # Event.find().remove() # We can not delete records in a capped collection

# Set the event as processed
exports.clear = (event) ->
  event.physical_processed = true; event.save();
