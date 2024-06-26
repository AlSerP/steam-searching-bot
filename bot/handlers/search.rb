module Bot
  module Handlers
    class Search < Bot::Handlers::Base
      CONFIRMATION = %w[да д yes y].freeze
      QUALITIES = {
        'bs' => '(Закаленное в боях)',
        'ww' => '(Поношенное)',
        'ft' => '(После полевых испытаний)',
        'mw' => '(Немного поношенное)',
        'fn' => '(Прямо с завода)',
        'no' => ''
      }.freeze
      @@current_searches = {}

      def initialize(chat_id, username)
        super(chat_id)

        @username = username
        @user_search = @@current_searches[@user.tg_id]
      end

      def perform(**args)
        if args.include? :callback
          perform_callback(args)
        else
          perform_message(args)
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

        $bot.logger.error "Steam search error with #{e.message}"
        notice_steam_error
      end

      def self.searching?(id)
        $bot.logger.debug(
          "Searching in #{@@current_searches} with #{id} is #{@@current_searches.key? id}"
        )
        @@current_searches.key? id
      end

      private

      def perform_callback(args)
        return notice_unknown if @user_search.nil?

        if @user_search.choosing_quality?
          quality = args[:callback]
          $bot.logger.info "Callback with #{quality}"

          @user_search.query = [@user_search.query, QUALITIES[quality]].join(' ')
          handle_query(@user_search.query)
        elsif @user_search.confirming?
          answer = args[:callback]
          handle_answer(answer)
        else
          notice_unknown
        end
      end

      def perform_message(args)
        if @user_search.nil?
          start_search
        elsif @user_search.entering_query?
          @user_search.query = args[:message]
          @user_search.next_step!
          ask_quality(@user_search.query)
        end
      end

      def start_search
        ask_query

        @user_search = Bot::UserSearch.new(@user.tg_id)
        @@current_searches[@user.tg_id] = @user_search

        $bot.logger.info(
          "User uid=\"#{@user.tg_id}\" start searching. "\
          "Searchers count=\"#{@@current_searches.size}\""
        )
      end

      def handle_query(query)
        request_s = SteamAPI::ItemSearch::Request.new(query)
        notice_perform_search(query)
        @user_search.next_step!
        response_s = request_s.send

        if response_s.empty?
          $bot.logger.info("User uid=\"#{@user.tg_id}\" query=\"#{query}\". No result")
          finish_search!
          notice_no_result

          return nil
        end

        $bot.logger.info(
          "User uid=\"#{@user.tg_id}\" query=\"#{query}\". "\
          "Find #{response_s.search_result_hash}"
        )

        request_p = SteamAPI::ItemPrice::Request.new(response_s.search_result_hash)
        response_p = request_p.send

        $bot.logger.debug(
          "Price for item_hash=\"#{response_s.search_result_hash}\""\
          "price=\"#{response_p.median_price}\""
        )

        @user_search.add_results([response_s])
        @user_search.next_step!

        ask_confirm_favorite search_result, response_p.median_price
      end

      def handle_answer(answer)
        unless confirmed?(answer)
          finish_search!
          notice_favorite_canceled

          $bot.logger.info(
            "User uid=\"#{@user.tg_id}\" item=\"#{search_result_hash}\" cancel favoring"
          )

          return false
        end

        finish_search!
        if add_to_favorite
          notice_favorite_confirmed(search_result)
          $bot.logger.info(
            "User uid=\"#{@user.tg_id}\" item=\"#{search_result_hash}\" start favoring"
          )
        else
          notice_already_favorite(search_result)
          $bot.logger.info(
            "User uid=\"#{@user.tg_id}\" item=\"#{search_result_hash}\" already favoring"
          )
        end

        true
      end

      def finish_search!
        @user_search.finish!
        @@current_searches.delete @user.tg_id
      end

      def add_to_favorite
        favorite = @user.favorites.with_item(search_result_hash).to_a[0]

        $bot.logger.info(
          "Favorites result hash=\"#{search_result_hash}\" result=\"#{favorite}\""
        )

        return false unless favorite.nil?

        request = SteamAPI::ItemPrice::Request.new(search_result_hash)
        response = request.send

        item = Item.find_or_create_by(hash_name: search_result_hash)
        item.price = response.median_price
        item.save

        @user.favorites.create(
          item: item,
          original_price: response.median_price
        )

        true
      end

      def ask_quality(query)
        Bot::Messages::AskQuality.send(chat_id: @user.tg_id, query: query)
      end

      def ask_query
        Bot::Messages::StartSearch.send(chat_id: @user.tg_id)
      end

      def notice_perform_search(query)
        Bot::Messages::PerformSearch.send(chat_id: @user.tg_id, query: query)
      end

      def notice_no_result
        Bot::Messages::NoResult.send(chat_id: @user.tg_id)
      end

      def ask_confirm_favorite(result, price)
        Bot::Messages::ConfirmFavorite.send(chat_id: @user.tg_id, result: result, price: price)
      end

      def notice_favorite_confirmed(item)
        Bot::Messages::FavoriteConfirmed.send(chat_id: @user.tg_id, item: item)
      end

      def notice_favorite_canceled
        Bot::Messages::FavoriteCanceled.send(chat_id: @user.tg_id)
      end

      def notice_already_favorite(item)
        Bot::Messages::AlreadyFavorite.send(chat_id: @user.tg_id, item: item)
      end

      def notice_unknown
        Bot::Messages::Unknown.send(chat_id: @user.tg_id)
      end

      def notice_steam_error
        Bot::Messages::SteamError.send(chat_id: @user.tg_id)
      end

      def confirmed?(answer)
        return false if answer.nil?

        CONFIRMATION.include?(answer.downcase)
      end

      def search_result
        @user_search.results.last.search_result
      end

      def search_result_hash
        @user_search.results.last.search_result_hash
      end
    end
  end
end
