module Bot
  module Messages
    class AddSteamIdError < Base
      class << self
        def text(args)
          "Не удалось получить доступ к инвентарю с полученным steam id"
        end
      end
    end
  end
end
