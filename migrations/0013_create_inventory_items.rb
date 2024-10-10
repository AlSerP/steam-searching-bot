ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?('inventory_items')
    create_table :inventory_items do |table|
      table.references :inventory, index: true, foreign_key: true
      table.references :item, index: true, foreign_key: true
    end
  end
end
