module Bot
  module Messages
    class SteamError < Base
      class << self
        def text(_args)
          "Не удалось подключитсья к Steam.\n" \
          'Попробуйте позже'
        end
      end
    end
  end
end
