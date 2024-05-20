module Bot
  module Handlers
    class EnableReportDelivery < Bot::Handlers::Base
      def initialize(chat_id, _username)
        super(chat_id)
      end

      def perform
        @user.enable_report_delivery
        Bot::Messages::EnableReportDelivery.send(chat_id: @user.tg_id, username: @username)
      end
    end
  end
end
