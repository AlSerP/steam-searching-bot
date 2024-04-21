module Answers
  class Price
    class << self
      def text(item_hash, price)
        "Предмет: #{item}\n"\
        "Текущая цена: #{price}"
      end

      def get_price(item_hash)
        response = SteamAPI::ItemPrice::Request.new(item_hash).send
        response.median_price
      end

      def send(chat_id, item_hash)
        $bot.api.send_message(chat_id: chat_id, text: text(item_hash, get_price(item_hash)))
      end
    end
  end
end