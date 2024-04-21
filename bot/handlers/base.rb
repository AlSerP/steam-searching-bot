module Bot
  module Handlers
    class Base
      def initialize(chat_id)
        @chat_id = chat_id
      end

      def perform; end
    end
  end
end
