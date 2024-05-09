module Bot
  module Messages
    class Favorites < Base
      class << self
        def text(args)
          message = "Ваши избранные предметы:\n"
          message = "Резулярный отчет:\n" if args[:report]

          args[:items].each do |item|
            message << "#{ item[0] }\n" \
            "Цена: #{ item[1] } (#{ price_diff_view(item[2][1][:price]) })\n"\
            "За всё время: #{ price_diff_view(item[2][0][:price]) }"\
            "#{ percent_diff_view(item[2][0][:percent]) }\n\n"
          end

          message << "Отчет за #{ DateTime.now.new_offset(3.0/24).strftime('%d/%m/%Y - %H:%M') }"
          message << "\nЧтобы отключить регулярную рассылку: /disable_reports" if args[:report]
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
            "+#{diff.round(2)} руб."
          elsif diff.negative?
            "-#{diff.abs.round(2)} руб."
          else
            "Нет данных"
          end
        end
      end
    end
  end
end
