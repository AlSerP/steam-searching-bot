ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?('users')
    create_table :users do |table|
      table.column :tg_id, :string
      table.column :first_name, :string
    end
  end
end
