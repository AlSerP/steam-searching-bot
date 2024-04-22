module Bot
  module Messages
    class Base
      class << self
        def text(args); end

        def send(chat_id:, **text_args)
          $bot.api.send_message(chat_id: chat_id, text: text(text_args))
        end
      end
    end
  end
end
