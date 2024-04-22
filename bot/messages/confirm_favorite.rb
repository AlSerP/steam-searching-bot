module Bot
  module Messages
    class ConfirmFavorite < Base
      class << self
        def text(args)
          "Результат поиска:\n"\
          "#{ args[:result] } | Цена: #{ args[:price] }\n\n"\
          "Добавить в избранное?"
        end

        def markup(args)
          kb = [[
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Да', callback_data: 'yes'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Нет', callback_data: 'no')
          ]]
          Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        end
      end
    end
  end
end
