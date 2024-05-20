module Bot
  module Messages
    class FavoriteConfirmed < Base
      class << self
        def text(args)
          "Предмет добавлен в ваше избранное:\n"\
          "#{args[:item]}\n\n"\
          'Продолжить поиск /search'
        end
      end
    end
  end
end
