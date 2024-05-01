module Bot
  module Messages
    class Favorites < Base
      class << self
        def text(args)
          message = "Ваши избранные предметы:\n"
          args[:items].each do |item|
            message << "#{ item[0] }\n" \
            "Цена: #{ item[1] } (#{ price_diff_view(item[2][1][:price]) })\n"\
            "За всё время: #{ price_diff_view(item[2][0][:price]) }руб."\
            "#{ percent_diff_view(item[2][0][:percent]) }\n\n"
          end

          message << "Отчет за #{ DateTime.now.strftime('%d/%m/%Y - %H:%M') }"
        end

        private

        def percent_diff_view(diff)
          if diff.nil?
            ""
          elsif diff.zero?
            ""
          elsif diff.positive?
            " | +#{diff.round(1)}%"
          elsif diff.negative?
            " | -#{diff.abs.round(1)}%"
          else
            ""
          end
        end

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
