module Bot
  module Messages
    class SteamError < Base
      class << self
        def text(args)
          "Не удалось подключитсья к Steam.\n" \
          "Попробуйте позже"
        end
      end
    end
  end
end
