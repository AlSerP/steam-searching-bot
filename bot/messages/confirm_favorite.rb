module Bot
  module Messages
    class ConfirmFavorite < Base
      class << self
        def text(args)
          "Результат поиска:\n"\
          "#{ args[:result] } | Цена: #{ args[:price] }\n\n"\
          "Добавить в избранное?"
        end
      end
    end
  end
end
