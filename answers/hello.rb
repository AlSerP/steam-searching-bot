module Answers
  class Hello
    class << self
      def text(username)
        "Привет, #{username}!\n"\
        "Я помогу тебе отслеживать цены на твои любимые предметы. "\
        "Для добавления нового предмета введи /search"
      end

      def send(chat_id, username)
        $bot.api.send_message(chat_id: chat_id, text: text(username))
      end
    end
  end
end
