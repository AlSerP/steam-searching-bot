class InventoryItem < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :item

  scope :report_view, -> { joins(:item).pluck(:hash_name, :price, :last_price) }

  UPDATE_DELAY = 0

  def update_price!
    return unless !item.updated_at.nil? && item.updated_at > DateTime.now - UPDATE_DELAY
    
    old_price = item.price
    item.update_price! 
    update_attribute(:last_price, old_price)
  end
end
