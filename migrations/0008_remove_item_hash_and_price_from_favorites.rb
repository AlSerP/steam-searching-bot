ActiveRecord::Schema.define do
  remove_column :favorites, :price, :string
  remove_column :favorites, :item_hash, :string
end
