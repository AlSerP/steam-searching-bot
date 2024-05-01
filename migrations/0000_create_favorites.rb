ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?('favorites')
    create_table :favorites do |table|
      table.column :item_hash, :string
      table.column :price, :string
      table.column :original_price, :string
    end
  end
end
