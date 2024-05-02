require_relative 'config/config'

# Connect and configure database
require_relative 'config/database'

raise "Can't connect to the Database" unless Database.configure

require_relative 'bot/bot'
