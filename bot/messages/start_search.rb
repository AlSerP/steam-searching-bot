module Bot
  module Messages
    class StartSearch < Base
      class << self
        def text(_args)
          'Введите название предмета:'
        end
      end
    end
  end
end
