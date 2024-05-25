class Item < ActiveRecord::Base
  has_many :favorites

  def update_price!
    new_price = price_to_f(SteamAPI::ItemPrice::Request.new(hash_name).send.median_price)

    update_attribute!(:price, new_price)
    update_attribute!(:updated_at, DateTime.now)
  end

  private

  def price_to_f(price)
    price.sub(',', '.').split(' ')[0].to_f
  end
end
