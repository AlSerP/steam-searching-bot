module Bot
  module Messages
    class Inventory < Base
      class << self
        def text(args)
          res = "Сейчас отслеживается #{args[:items].count} уникальных предмета в вашем инвентаре.\n\n"
          res << "Важнейшие изменения за последнее время:\n"
          args[:items].each do |item|
            res << "#{item[0]}\n"
            res << "Цена: #{item[1]} руб. (#{price_diff_view(item[3])})\n\n"
          end

          res
        end

        private

        def percent_diff_view(diff)
          if diff.nil?
            ''
          elsif diff.zero?
            ''
          elsif diff.positive?
            " | +#{diff.round(1)}%"
          elsif diff.negative?
            " | -#{diff.abs.round(1)}%"
          else
            ''
          end
        end

        def price_diff_view(diff)
          if diff.nil?
            'Нет данных'
          elsif diff.zero?
            'Нет изменений'
          elsif diff.positive?
            "+#{diff.round(2)} руб."
          elsif diff.negative?
            "-#{diff.abs.round(2)} руб."
          else
            'Нет данных'
          end
        end
      end
    end
  end
end
