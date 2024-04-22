module Bot
  module Messages
    class Greeting < Base
      class << self
        def text(args)
          "Привет, #{args[:username]}!\n"\
          "Я помогу тебе отслеживать цены на твои любимые предметы. "\
          "Для добавления нового предмета введи /search"
        end
      end
    end
  end
end
