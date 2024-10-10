module Bot
  module Handlers
    class Base
      def initialize(chat_id)
        @user = User.find_by(tg_id: chat_id)
        @user ||= User.create!(tg_id: chat_id)
      end

      def perform; end

      private

      def delete_message(message_id)
        $bot.api.delete_message(chat_id: @user.tg_id, message_id: message_id)
      end

      def notice_unknown
        Bot::Messages::Unknown.send(chat_id: @user.tg_id)
      end
    end
  end
end
