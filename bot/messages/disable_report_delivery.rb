module Bot
  module Messages
    class DisableReportDelivery < Base
      class << self
        def text(_args)
          "Вы отключили рассылку отчетов\n"\
          'Чтобы включить её обратно: /enable_reports'
        end
      end
    end
  end
end
