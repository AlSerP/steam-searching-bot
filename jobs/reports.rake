require 'date'

require_relative '../config/config'

namespace :reports do
  token = File.read(Bot::Config::TOKEN_PATH)
  $bot = Telegram::Bot::Client.new(token)
  logger = Logger.new('logs/tasks.log')

  task :send do
    logger.info 'Start item price updating'
    Item.all.each do |item|
      res = SteamAPI::ItemPrice::Request.new(item.hash_name).send
      item.update_price!(res.median_price)
    end
    logger.info "Updated #{Item.count} items"

    User.where(report_delivery: true).each do |user|
      favorites = user.favorites

      next if favorites.empty?

      prices = []

      favorites.each do |fav|
        diff = fav.current_diff
        diff_o = diff[:original_diff]
        diff_l = diff[:last_diff]

        prices << [fav.item.hash_name, diff[:price], [diff_o, diff_l]]
      end

      prices.sort_by! { |p| -p[2][0][:percent] }

      Bot::Messages::Favorites.send(chat_id: user.tg_id, items: prices, report: true)
      logger.info "Send report to #{user.tg_id}"
    end
  end
end
