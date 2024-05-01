module Bot
  module Handlers
    class Greeting < Bot::Handlers::Base
      def initialize(chat_id, username)
        super(chat_id)

        @username = username
      end

      def perform
        Bot::Messages::Greeting.send(chat_id: @user.tg_id, username: @username)
      end
    end
  end
end
