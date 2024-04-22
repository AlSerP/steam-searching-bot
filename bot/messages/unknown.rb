module Bot
  module Messages
    class Unknown < Base
      class << self
        def text(args)
          "Неизвестная команда"
        end
      end
    end
  end
end
