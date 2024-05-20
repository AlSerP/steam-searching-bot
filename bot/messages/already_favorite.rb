module Bot
  module Messages
    class AlreadyFavorite < Base
      class << self
        def text(args)
          "Предмет уже в избранном:\n"\
          "#{args[:item]}"
        end
      end
    end
  end
end
