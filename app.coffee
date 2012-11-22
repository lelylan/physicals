logic = require './lib/logic'

console.log 'DEBUG: webhooks worker up and running' if process.env.DEBUG
logic.execute()
