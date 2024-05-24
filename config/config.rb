# Load Libraries
require 'steam-api'
require 'telegram/bot'
require 'date'
require 'active_record'
require 'rake'

module Bot
  module Config
    TOKEN_PATH = 'config/token'.freeze
    ERROR_TIMEOUT = 5 # sec
    $bot = nil

    MAIN_LOGS = 'logs/main.log'.freeze
    DB_LOGS = 'logs/db.log'.freeze
    TASKS_LOGS = 'logs/tasks.log'.freeze
  end
end

# Load components
require_relative '../bot/models'
require_relative '../bot/messages'
require_relative '../bot/handlers'
require_relative '../bot/main_handler'

# Connect and configure database
require_relative 'database'

raise "Can't connect to the Database" unless Database.configure
