module Bot
  module Messages
    class PerformSearch < Base
      class << self
        def text(args)
          "Ищем предмет \"#{args[:query]}\""
        end
      end
    end
  end
end
