ActiveRecord::Schema.define do
  add_column :users, :report_delivery, :boolean, default: true
end
