module Bot
  module Messages
    class NoResult < Base
      class << self
        def text(_args)
          "Не удалось ничего найти :(\n"\
          'Попробуйте повторить /search с другим запросом'
        end
      end
    end
  end
end
