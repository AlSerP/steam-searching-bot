module Bot
  module Messages
    class AskQuality < Base
      class << self
        def text(args)
          "Уточните качество предмета \"#{args[:query]}\":"
        end

        def markup(_args)
          kb = [
            [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Закаленное в боях',
                                                             callback_data: 'bs'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Поношенное',
                                                             callback_data: 'ww'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'После полевых испытаний',
                                                             callback_data: 'ft')
            ],
            [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Немного поношенное',
                                                             callback_data: 'mw'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Прямо с завода',
                                                             callback_data: 'fn'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: '(Без качества)',
                                                             callback_data: 'no')
            ]
          ]
          Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        end
      end
    end
  end
end
