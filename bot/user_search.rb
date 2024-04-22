module Bot
  class UserSearch
    SEARCH_STATUSES = [
      :entering_query,
      :searching,
      :confirmation,
      :finished
    ].freeze

    attr_reader :status, :results

    def initialize(id)
      @status = :entering_query
      @id = id
      @results = []
    end

    def add_results(results)
      @results += results
    end

    def next_step!
      status_id = SEARCH_STATUSES.find_index(@status) + 1
      @status = SEARCH_STATUSES[status_id] if status_id < SEARCH_STATUSES.size
      $bot.logger.debug("User uid=\"#{ @id }\" new status=\"#{ @status }\"")

      @status
    end

    def entering_query?
      @status == :entering_query
    end

    def confirming?
      @status = :confirmation
    end

    def finish!
      @status = :finished
    end
  end
end
