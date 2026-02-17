require 'date'

require_relative '../config/config'

namespace :inventory do
  token = File.read(Bot::Config::TOKEN_PATH).strip
  $bot = Telegram::Bot::Client.new(token)
  logger = Logger.new(Bot::Config::TASKS_LOGS)

  task :update do
    logger.info 'Start inventory updating'
    inventories = Inventory.all
    inventories.all.each do |inventory|
      inventory.update_items!
    end
    logger.info "Updated #{inventories.count} inventories"
  end
end
