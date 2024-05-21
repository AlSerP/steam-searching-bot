ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?('items')
    create_table :items do |table|
      table.column :hash_name, :string
      table.column :price, :float
    end
  end
end
