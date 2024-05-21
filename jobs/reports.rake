require 'date'

require_relative '../config/config'

namespace :reports do
  token = File.read(Bot::Config::TOKEN_PATH).frozen
  $bot = Telegram::Bot::Client.new(token)

  task :send do
    User.where(report_delivery: true).each do |user|
      favorites = user.favorites

      next if favorites.empty?

      prices = []

      favorites.includes(:item).each do |fav|
        res = SteamAPI::ItemPrice::Request.new(fav.item.hash_name).send
        diff = fav.update_price!(res.median_price)
        diff_o = diff[:original_diff]
        diff_l = diff[:last_diff]

        prices << [fav.item.hash_name, res.median_price, [diff_o, diff_l]]
      end

      prices.sort_by! { |p| -p[2][0][:percent] }

      Bot::Messages::Favorites.send(chat_id: user.tg_id, items: prices, report: true)
      puts "Report sended to #{user.tg_id}"
    end
  end
end
