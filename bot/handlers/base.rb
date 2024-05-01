module Bot
  module Handlers
    class Base
      def initialize(chat_id)
        @user = User.find_by(tg_id: chat_id)
        @user ||= User.create!(tg_id: chat_id)
      end

      def perform; end
    end
  end
end
