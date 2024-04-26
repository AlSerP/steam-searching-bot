class Favorite < ActiveRecord::Base
  def update_price!(new_price)
    diff_o, diff_l = original_price_diff(new_price), last_price_diff(new_price) unless price.nil?
    update_attribute(:price, new_price)

    [diff_o, diff_l]
  end

  private

  def original_price_diff(new_price)
    price_to_f(new_price) - price_to_f(original_price)
  end

  def last_price_diff(new_price)
    price_to_f(new_price) - price_to_f(price)
  end

  def price_to_f(price)
    price.sub(',', '.').split(' ')[0].to_f
  end
end
