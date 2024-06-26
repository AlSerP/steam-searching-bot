module Bot
  module Handlers
    class Favorites < Bot::Handlers::Base
      def initialize(chat_id, username)
        super(chat_id)

        @username = username
      end

      def perform
        favorites = @user.favorites

        prices = []

        $bot.logger.info(
          "User uid=\"#{@user.tg_id}\" favorites count=\"#{favorites.count}\". List"
        )
        $bot.logger.debug(
          "User uid=\"#{@user.tg_id}\". Favorites: #{favorites.includes(:item).map {|fav| fav.item.hash_name}}"
        )

        favorites.includes(:item).each do |fav|
          if fav.item.updated_at.nil? || fav.item.updated_at < DateTime.now - 10.minutes
            diff = fav.update_price!
          else
            diff = fav.current_diff
          end

          prices << [
            fav.item.hash_name,
            diff[:price],
            [
              diff[:original_diff],
              diff[:last_diff]
            ]
          ]
        end
        $bot.logger.debug(
          "User uid=\"#{@user.tg_id}\". Favorites Composed: #{prices}"
        )

        prices.sort_by! { |p| -p[2][0][:percent] }

        Bot::Messages::Favorites.send(chat_id: @user.tg_id, items: prices)
      rescue NoMethodError => e
        $bot.logger.error "NoMethod #{e.message} with #{prices} backtrace #{e.backtrace}"
        notice_steam_error
      rescue SteamResponseError => e
        $bot.logger.error "Steam error #{e.message} with #{e.response}"
        notice_steam_error
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

        $bot.logger.error "Steam search error with #{e.message}"
        notice_steam_error
      end

      private

      def notice_steam_error
        Bot::Messages::SteamError.send(chat_id: @user.tg_id)
      end
    end
  end
end
