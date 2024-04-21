module Bot
  module Messages
    class Base
      class << self
        def text(*args); end

        def send(chat_id:, **args)
          $bot.api.send_message(chat_id: chat_id, text: text(args))
        end
      end
    end
  end
end
