module Bot
  module Handlers
    class DisableReportDelivery < Bot::Handlers::Base
      def initialize(chat_id, _username)
        super(chat_id)
      end

      def perform
        @user.disable_report_delivery
        Bot::Messages::DisableReportDelivery.send(chat_id: @user.tg_id, username: @username)
      end
    end
  end
end
