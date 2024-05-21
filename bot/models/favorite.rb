class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  scope :with_item, ->(hash) { joins(:item).merge(Item.where(hash_name: hash)) }

  def update_price!(new_price)
    unless price.nil?
      diff_o = original_price_diff(new_price)
      diff_l = last_price_diff(new_price)
    end

    item.update_attribute(:price, new_price)

    {
      original_diff: { price: diff_o, percent: percent_diff(diff_o) },
      last_diff: { price: diff_l, percent: percent_diff(diff_l) }
    }
  end

  def price
    item.price
  end

  private

  def original_price_diff(new_price)
    return unless original_price

    price_to_f(new_price) - price_to_f(original_price)
  end

  def last_price_diff(new_price)
    return unless original_price

    price_to_f(new_price) - price_to_f(price)
  end

  def percent_diff(diff)
    return nil unless diff
    (diff / price_to_f(original_price) * 100)
  end

  def price_to_f(price)
    return price if price.class == Float
    price.sub(',', '.').split(' ')[0].to_f
  end
end
