module Answers
  class Search
    class << self
      def text
        "Введите название предмета:"
      end

      def result_text(result, result_hash)
        "Результат поиска:\n"\
        "#{result}\n"\
        "#{result_hash}\n\n"\
        "Добавить в избранное?"
      end

      def empty_result_text
        "Ничего не найдено"
      end

      def confirmed_text
        "Предмет добавлен"
      end

      def canceled_text
        "Предмет не был добавлен"
      end

      def send(chat_id)
        $bot.api.send_message(chat_id: chat_id, text: text)
      end

      def handle_and_send(chat_id, query)
        
        request = SteamAPI::ItemSearch::Request.new(query)
        response = request.send

        $bot.logger.debug("Find \"#{response.search_result_hash}\" to uid=\"#{chat_id}\" by query=\"#{query}\"")

        $bot.api.send_message(
          chat_id: chat_id, 
          text: response.search_result.nil? ? empty_result_text : result_text(
              response.search_result,
              response.search_result_hash
            )
        )
      end

      def confirm_and_send(chat_id, answer)
        if answer.downcase == 'да'
          $bot.api.send_message(chat_id: chat_id, text: confirmed_text)
          return true
        end

        $bot.api.send_message(chat_id: chat_id, text: canceled_text)
        false
      end
    end
  end
end
