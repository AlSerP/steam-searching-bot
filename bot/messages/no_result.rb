module Bot
  module Messages
    class NoResult < Base
      class << self
        def text(args)
          "Не удалось ничего найти :(\n"\
          "Попробуйте повторить /search с другим запросом"
        end
      end
    end
  end
end
