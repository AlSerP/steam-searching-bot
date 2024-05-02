# Load Libraries
require 'steam-api'
require 'telegram/bot'
require 'date'
require 'active_record'

module Bot
  module Config
    TOKEN_PATH = 'config/token'
    ERROR_TIMEOUT = 5 # sec
    $bot = nil
  end
end 


# Load components
require_relative '../bot/models'
require_relative '../bot/messages'
require_relative '../bot/handlers'
require_relative '../bot/main_handler'
