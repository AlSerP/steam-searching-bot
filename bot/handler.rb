module Bot
  class MainHandler
    def self.perform(message)
      id = message.chat.id
      user = message.from.first_name

      case message
      when Telegram::Bot::Types::Message        
        case message.text
        when '/start'
          Bot::Handlers::Greeting.new(id, user).perform
        when '/search'
          Bot::Handlers::Search.new(id, user).perform
        else
          if Bot::Handlers::Search.searching?(id)
            Bot::Handlers::Search.new(id, user).perform(message: message.text)
          else
            Bot::Handlers::Unknown.new(id, user).perform
          end
        end
      end
    end
  end
end
