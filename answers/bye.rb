module Answers
  class Bye
    class << self
      def text(username)
        "Пока, #{username}"
      end

      def send(chat_id, username)
        $bot.api.send_message(chat_id: chat_id, text: text(username))
      end
    end
  end
end
