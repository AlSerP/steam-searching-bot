class Item < ActiveRecord::Base
  has_many :favorites

  def update_price!
    new_price = SteamAPI::ItemPrice::Request.new(hash_name).send

    update_attribute!(:price, new_price.median_price)
    update_attribute!(:updated_at, DateTime.now)
  end

  # def update_price!(new_price)
  #   update_attribute(:price, new_price)
  #   update_attribute(:updated_at, DateTime.now)
  # end
end
