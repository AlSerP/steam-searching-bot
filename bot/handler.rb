module Bot
  class Handler
    SEARCH_STATUSES = {
      '0' => :entering_query,
      '1' => :confirmation,
    }

    def initialize
      @current_searches = {}
    end

    def perform(message)
      id = message.chat.id
      user = message.from.first_name

      case message
      when Telegram::Bot::Types::Message        
        case message.text
        when '/start'
          Answers::Hello.send(id, user)
        when '/search'
          unless searching?(id)
            @current_searches[id] = SEARCH_STATUSES['0']
            $bot.logger.debug("Add uid=\"#{id}\" to the Current Searches. Current size=\"#{@current_searches.size}\"")
          end
          
          Answers::Search.send(id)
        when '/end'
          Answers::Bye.send(id, user)
        else
          if searching?(id)
            if entering_query?(id)
              Answers::Search.handle_and_send(id, message.text)
              @current_searches[id] = SEARCH_STATUSES['1']
            elsif confirmation?(id)
              confirmed = Answers::Search.confirm_and_send(id, message.text)
              
              # Answers::Price.send() if confirmed

              @current_searches.delete id
            end

            $bot.logger.debug("Remove uid=\"#{id}\" from the Current Searches. Current size=\"#{@current_searches.size}\"")
          else
            Answers::Unknown.send(id)
          end
        end
      end
    end

    private

    def searching?(id)
      @current_searches.keys.include? id
    end

    def entering_query?(id)
      !@current_searches.nil? && @current_searches[id] == SEARCH_STATUSES['0']
    end

    def confirmation?(id)
      !@current_searches.nil? && @current_searches[id] == SEARCH_STATUSES['1']
    end
  end
end