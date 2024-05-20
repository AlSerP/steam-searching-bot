module Bot
  module Messages
    class Base
      class << self
        def text(args); end

        def markup(_args)
          nil
        end

        def send(chat_id:, **kwargs)
          $bot.api.send_message(chat_id: chat_id, text: text(kwargs), reply_markup: markup(kwargs))
        end
      end
    end
  end
end
