module Bot
  module Messages
    class Favorites < Base
      class << self
        def text(args)
          message = "Ваши избранные предметы:\n"
          args[:items].each do |item|
            message << "#{ item[0] } | Цена: #{ item[1] } (#{ price_diff_view(item[2]) })\n"
          end

          message << "\nОтчет за #{ DateTime.now.strftime('%d/%m/%Y - %H:%M') }"
        end

        private

        def price_diff_view(diff)
          if diff.nil?
            "Нет данных"
          elsif diff.zero?
            "Нет изменений"
          elsif diff.positive?
            "+#{diff.round(2)}"
          elsif diff.negative?
            "-#{diff.abs.round(2)}"
          else
            "Нет данных"
          end
        end
      end
    end
  end
end
