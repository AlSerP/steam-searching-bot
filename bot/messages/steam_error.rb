module Bot
  module Messages
    class SteamError < Base
      class << self
        def text(_args)
          "Не удалось подключиться к Steam.\n" \
          'Попробуйте позже'
        end
      end
    end
  end
end
