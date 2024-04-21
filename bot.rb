# frozen_string_literal: true

require 'steam-api'
require 'rubygems'
require 'telegram/bot'

token = File.read('config/token')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
      when '/end'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "I don't understand you :(")
      end
    end
  end
end

# item = 'awp | азимов (после полевых)'

# request = SteamAPI::ItemSearch::Request.new(item)
# response = request.send

# puts "RESULT HASH #{response.search_result_hash}"
