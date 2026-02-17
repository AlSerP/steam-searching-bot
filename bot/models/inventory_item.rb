class InventoryItem < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :item

  # scope :report_view, -> { joins(:item).pluck(:hash_name, :last_price) }

  UPDATE_DELAY = 0

  def update_price!
    return if item.updated_at.present? && item.updated_at > DateTime.now - UPDATE_DELAY

    old_price = item.current_price
    item.update_price! 
    update(last_price: old_price)
  end
end
