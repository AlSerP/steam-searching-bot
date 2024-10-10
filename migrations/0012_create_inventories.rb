ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?('inventories')
    create_table :inventories do |table|
      table.column :updated_at, :datetime
      table.references :user, index: true, foreign_key: true
    end
  end
end
