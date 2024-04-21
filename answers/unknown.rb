module Answers
  class Unknown
    class << self
      def text
        "Неизвесная команда"
      end

      def send(chat_id)
        $bot.api.send_message(chat_id: chat_id, text: text)
      end
    end
  end
end
