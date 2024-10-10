class Inventory < ActiveRecord::Base
  has_many :inventory_items
  belongs_to :user

  # scope :items, -> { Item.where(id: inventory_items.pluck(:item)) }

  def fill(new_items)
    new_items.each do |new_item|
      next unless new_item[:marketable]
      $bot.logger.debug "Add item #{ new_item[:hash_name] } to inventory of #{ user.tg_id }"
      item = Item.find_or_create_by(hash_name: new_item[:hash_name])
      $bot.logger.debug "#{ InventoryItem.column_names }"
      InventoryItem.find_or_create_by(item: item, inventory: self)
    end
  end

  def report
    ii = inventory_items.report_view
    $bot.logger.info("Inventory of #{user.tg_id} count #{ ii.count } items")
    ii.reject! {|item| item[1].nil? || item[2].nil? }

    rep = ii.map do |item|
      item << item[1] - item[2]
    end

    $bot.logger.info("Inventory of #{user.tg_id} count #{ rep.count } tradable items")

    rep.sort_by! { |item| -item[3] }
    res = []
    res += rep[0..3]
    res += rep[-4..-1]

    res.count

    $bot.logger.info("Inventory of #{user.tg_id} count #{ res.count } tradable items")
    return res
  end

  def update
    # return if updated_at > DateTime.now - 1.hours

    $bot.logger.info("Start updating inventory of #{ user.tg_id }")

    bm = Benchmark.measure {
      inventory_items.includes(:item).first(10).each do |item|
        $bot.logger.debug("Get price of #{ item.item.hash_name } - #{ item.item.price }")
        item.update_price! 
      end
    }

    $bot.logger.info("End updating inventory of #{ user.tg_id } per #{bm}")
    update_attribute(:updated_at, DateTime.now)
  end

  private

  def items
    Item.where(id: inventory_items.pluck(:item_id))
  end
end