module Bot
  module Handlers
    class Unknown < Bot::Handlers::Base
      def initialize(chat_id, username)
        super(chat_id)

        @username = username
      end

      def perform
        Bot::Messages::Unknown.send(chat_id: @user.tg_id)
      end
    end
  end
end
