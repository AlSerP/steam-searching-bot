class Favorite < ActiveRecord::Base
  def update_price!(new_price)
    diff = price_diff(new_price) unless price.nil?
    update_attribute(:price, new_price)

    diff
  end
  
  def price_diff(new_price)
    price_to_f(new_price) - price_to_f(original_price)
  end

  private

  def price_to_f(price)
    price.sub(',', '.').split(' ')[0].to_f
  end
end