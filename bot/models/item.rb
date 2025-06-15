class Item < ActiveRecord::Base
  has_many :favorites
  has_many :item_price_histories

  # scope :with_current_price, lambda {
  # # default_scope {
  #   joins(:item_price_histories)
  #     .where('item_price_histories.created_at = (
  #       SELECT MAX(iph.created_at)
  #       FROM item_price_histories AS iph
  #       WHERE iph.item_id = items.id
  #     )')
  #     .select(
  #       'items.*',
  #       'item_price_histories.price as current_price',
  #       'item_price_histories.created_at as price_updated'
  #     )
  # }

  def update_price!
    res = SteamAPI::ItemPrice::Request.new(hash_name).send

    if res.empty? || !res.success? || res.median_price.nil?
      $bot.logger.debug "Skipped #{hash_name}"
      return
    end

    $bot.logger.debug "Request is #{hash_name} - #{res.inspect}"

    new_price = price_to_f(res.median_price)

    item_price_histories.create(price: new_price)
    update(current_price: new_price)

    new_price
  end

  private

  def price_to_f(price)
    price.sub(',', '.').split(' ')[0].to_f
  end
end
