module Bot
  class MainHandler
    def self.perform(message)
      user = message.from.first_name

      case message
      when Telegram::Bot::Types::CallbackQuery
        id = message.from.id
        data = message.data
        $bot.logger.debug "Got callback from uid=\"#{id}\""

        Bot::Handlers::Search.new(id, user).perform(callback: data)
      when Telegram::Bot::Types::Message
        id = message.chat.id
        
        case message.text
        when '/start'
          Bot::Handlers::Greeting.new(id, user).perform
        when '/search'
          Bot::Handlers::Search.new(id, user).perform
        when '/favorites'
          Bot::Handlers::Favorites.new(id, user).perform
        else
          if Bot::Handlers::Search.searching?(id)
            $bot.logger.debug "User uid=\"#{id}\" continues search"
            Bot::Handlers::Search.new(id, user).perform(message: message.text)
          else
            Bot::Handlers::Unknown.new(id, user).perform
          end
        end
      end
    end
  end
end
