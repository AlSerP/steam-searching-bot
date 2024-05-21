ActiveRecord::Schema.define do
  add_reference :favorites, :item, foreign_key: true
end

Favorite.all.each do |fav|
  fav.item = Item.find_or_create_by(hash_name: fav.item_hash)
  fav.save
end
