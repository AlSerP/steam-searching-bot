original_prices_str = {}

Favorite.all.find_each do |fav|
  original_prices_str[fav.id] = fav.original_price
end

ActiveRecord::Schema.define do
  change_column :favorites, :original_price, :float
end

Favorite.all.find_each do |fav|
  next if original_prices_str[fav.id].is_a? Float
  price = original_prices_str[fav.id].sub(',', '.').split(' ')[0].to_f
  fav.update_attribute(:original_price, price)
end
