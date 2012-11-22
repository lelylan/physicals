logic = require './lib/logic'

console.log 'DEBUG: physical dispatcher up and running' if process.env.DEBUG
logic.execute()
