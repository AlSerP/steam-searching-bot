module Bot
  module Messages
    class EnableReportDelivery < Base
      class << self
        def text(_args)
          "Вы включили рассылку отчетов\n"\
          'Чтобы выключить: /disable_reports'
        end
      end
    end
  end
end
