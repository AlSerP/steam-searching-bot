module Bot
  module Messages
    class FavoriteCanceled < Base
      class << self
        def text(args)
          "Предмет не был добавлен в избранное\n"\
          "Продолжить поиск /search"
        end
      end
    end
  end
end
