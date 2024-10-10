module Bot
  module Messages
    class AskSteamId < Base
      class << self
        def text(args)
          "Чтобы начать отслеживать инвентарь - пришлите свой steam id"
        end
      end
    end
  end
end
