# frozen_string_literal: true

require 'steam-api'
require 'rubygems'
require 'telegram/bot'

require_relative 'answers'
require_relative 'bot/handler'

token = File.read('config/token')
$bot = nil

Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
  $bot = bot

  $bot.listen do |message|
    Bot::Handler.perform message
  end
end
