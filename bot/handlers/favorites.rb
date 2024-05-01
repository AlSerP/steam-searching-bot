module Bot
  module Handlers
    class Favorites < Bot::Handlers::Base
      def initialize(chat_id, username)
        super(chat_id)

        @username = username
      end

      def perform
        favorites = Favorite.where(chat_id: @chat_id)
        prices = []

        $bot.logger.info("User uid=\"#{ @chat_id }\" favorites count=\"#{ favorites.count }\". List")
        $bot.logger.debug(
          "User uid=\"#{ @chat_id }\". Favorites: #{favorites.map { |fav| fav.item_hash }}"
        )

        favorites.each do |fav|
          res = SteamAPI::ItemPrice::Request.new(fav.item_hash).send
          diff_o, diff_l = fav.update_price!(res.median_price)

          prices << [fav.item_hash, res.median_price, [diff_o, diff_l]]
        end
        $bot.logger.debug(
          "User uid=\"#{ @chat_id }\". Favorites Composed: #{ prices }"
        )

        Bot::Messages::Favorites.send(chat_id: @chat_id, items: prices)

      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        
        $bot.logger.error "Steam search error with #{e.message}" 
        notice_steam_error
      end

      private 

      def notice_steam_error
        Bot::Messages::SteamError.send(chat_id: @chat_id)
      end
    end
  end
end
