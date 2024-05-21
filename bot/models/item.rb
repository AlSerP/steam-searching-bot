class Item < ActiveRecord::Base
  has_many :favorites

  def update_price!(new_price)
    update_attribute(:price, new_price)
    update_attribute(:updated_at, DateTime.now)
  end
end
