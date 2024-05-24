class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  scope :with_item, ->(hash) { joins(:item).merge(Item.where(hash_name: hash)) }

  def update_price!
    item.update_price!
    current_diff
  end

  def current_diff
    item.update_price! if item.price.nil?
    item_price = item.price

    $bot.logger.debug "New item price #{item_price}"

    unless item_price.nil?
      diff_o = original_price_diff(item_price)
      diff_l = last_price_diff(item_price)
    end

    $bot.logger.debug "Diff_o #{diff_o} | Diff_l #{diff_l}"

    update_attribute(:last_price, item_price)

    {
      price: item_price,
      original_price: original_price,
      original_diff: { price: diff_o, percent: percent_diff(diff_o) },
      last_diff: { price: diff_l, percent: percent_diff(diff_l) }
    }
  end

  private

  def original_price_diff(new_price)
    return unless original_price

    new_price - price_to_f(original_price)
  end

  def last_price_diff(new_price)
    return unless last_price

    new_price - price_to_f(last_price)
  end

  def percent_diff(diff)
    return nil if diff.nil? || original_price.nil?
    (diff / price_to_f(original_price) * 100)
  end

  def price_to_f(price)
    return price unless price.is_a? String

    price.sub(',', '.').split(' ')[0].to_f
  end
end
