class Inventory < ActiveRecord::Base
  has_many :inventory_items
  belongs_to :user

  UPDATE_TIMEOUT_HOURS = 12
  # scope :items_data, -> {
  #   includes(inventory_items: :item).pluck(
  #     'items.hash_name',
  #     'items.current_price',
  #     'inventory_items.last_price'
  #   )
  # }

  def fill(new_items)
    new_items.each do |new_item|
      next unless new_item[:marketable]
      $bot.logger.debug "Add item #{ new_item[:hash_name] } to inventory of #{ user.tg_id }"
      item = Item.find_or_create_by(hash_name: new_item[:hash_name])
      InventoryItem.find_or_create_by(item: item, inventory: self)
    end
  end

  def report
    # return items_data

    ii = items_data
    $bot.logger.info("Inventory of #{user.tg_id} count #{ ii.count } items")
    ii.reject! {|item| item[1].nil? }

    items = ii.map do |item|
      price_diff = item[1] - item[2]
      item << price_diff
    end

    $bot.logger.info("Inventory of #{user.tg_id} count #{ items.count } tradable items")

    items.sort_by! { |item| -item[3] }
    report = {
      size: report.count,
      items: items[0..3] + items[-4..-1],
    }

    $bot.logger.info("Inventory of #{user.tg_id} count #{ report.count } tradable items")

    report
  end

  def update_items
    return if updated_at > DateTime.now - UPDATE_TIMEOUT_HOURS.hours

    $bot.logger.info("Start updating inventory of #{ user.tg_id }")

    bm = Benchmark.measure {
      inventory_items.includes(:item).each do |item|
        $bot.logger.debug("Get price of #{ item.item.hash_name }")
        item.update_price!
        sleep(1)
      end
    }

    $bot.logger.info("End updating inventory of #{ user.tg_id } per #{bm}")
    update_attribute(:updated_at, DateTime.now)
  end

  private

  def items
    Item.where(id: inventory_items.pluck(:item_id))
  end

  def items_data
    inventory_items.includes(:item).pluck(
      'items.hash_name',
      'items.current_price',
      'inventory_items.last_price'
    )
  end
end