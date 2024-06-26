# frozen_string_literal: true

token = File.read(Bot::Config::TOKEN_PATH)
Telegram::Bot::Client.run(token, logger: Logger.new(Bot::Config::MAIN_LOGS)) do |bot|
  $bot = bot

  $bot.listen do |message|
    Bot::MainHandler.perform message
  end
end
