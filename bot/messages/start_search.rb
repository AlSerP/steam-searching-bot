module Bot
  module Messages
    class StartSearch < Base
      class << self
        def text(args)
          "Введите название предмета:"
        end
      end
    end
  end
end
