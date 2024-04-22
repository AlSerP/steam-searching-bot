# Load Libraries
require 'steam-api'
require 'rubygems'
require 'telegram/bot'
require 'date'

# Configure
require_relative 'config/database'

raise "Can't connect to the Database" unless Database.configure

module Bot
  module Config
    TOKEN_PATH = 'config/token'
    $bot = nil
  end
end 


# Load components
require_relative 'bot/models'
require_relative 'bot/messages'
require_relative 'bot/handlers'
require_relative 'bot/handler'
require_relative 'bot/bot'
