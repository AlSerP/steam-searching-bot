module Bot
  module Messages
    class Unknown < Base
      class << self
        def text(_args)
          'Неизвестная команда'
        end
      end
    end
  end
end
