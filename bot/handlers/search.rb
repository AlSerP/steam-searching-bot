module Bot
  module Handlers
    class Search < Bot::Handlers::Base
      CONFIRMATION = ['да', 'д', 'yes', 'y']
      @@current_searches = {}

      def initialize(chat_id, username)
        super(chat_id)

        @username = username
        @user_search = @@current_searches[@chat_id]
      end

      def perform(**args)
        if @user_search.nil?
          start_search
        elsif @user_search.entering_query?
          query = args[:message]
          handle_query(query)
        elsif @user_search.confirming?
          answer = args[:message]
          handle_answer(answer)
        end
      end

      def self.searching?(id)
        @@current_searches.key? id
      end

      private

      def start_search
        ask_query

        @user_search = Bot::UserSearch.new(@chat_id)
        @@current_searches[@chat_id] = @user_search
        
        $bot.logger.debug(
          "User uid=\"#{ @chat_id }\" start searching. "\
          "Searchers count=\"#{ @@current_searches.size }\""
        )
      end

      def handle_query(query)
        request_s = SteamAPI::ItemSearch::Request.new(query)
        notice_perform_search(query)
        @user_search.next_step!
        response_s = request_s.send

        if response_s.empty?
          $bot.logger.debug("User uid=\"#{ @chat_id }\" query=\"#{ query }\". No result")
          finish_search!
          notice_no_result

          return nil
        end

        $bot.logger.debug(
          "User uid=\"#{ @chat_id }\" query=\"#{ query }\". "\
          "Find #{ response_s.search_result_hash }"
        )

        request_p = SteamAPI::ItemPrice::Request.new(response_s.search_result_hash)
        response_p = request_p.send

        $bot.logger.debug(
          "Price for item_hash=\"#{ response_s.search_result_hash }\""\
          "price=\"#{ response_p.median_price }\""
        )

        @user_search.add_results([response_s.search_result_hash])
        @user_search.next_step!

        ask_confirm_favorite response_s.search_result, response_p.median_price
      end

      def handle_answer(answer)
        finish_search!
        unless confirmed?(answer)
          notice_favorite_canceled
          
          return false
        end

        add_to_favorite
        notice_favorite_confirmed(@user_search.results.last)

        true
      end

      def finish_search!
        @user_search.finish!
        @@current_searches.delete @chat_id
      end

      def add_to_favorite
        return
      end

      def ask_query
        Bot::Messages::StartSearch.send(chat_id: @chat_id)
      end

      def notice_perform_search(query)
        Bot::Messages::PerformSearch.send(chat_id: @chat_id, query: query)
      end

      def notice_no_result
        Bot::Messages::NoResult.send(chat_id: @chat_id)
      end

      def ask_confirm_favorite(result, price)
        Bot::Messages::ConfirmFavorite.send(chat_id: @chat_id, result: result, price: price)
      end

      def notice_favorite_confirmed(item)
        Bot::Messages::FavoriteConfirmed.send(chat_id: @chat_id, item: item)
      end

      def notice_favorite_canceled
        Bot::Message::FavoriteCanceled.send(chat_id: @chat_id)
      end

      def confirmed?(answer)
        CONFIRMATION.include?(answer.downcase)
      end
    end
  end
end
