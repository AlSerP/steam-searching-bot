ActiveRecord::Schema.define do
  add_reference :favorites, :user, foreign_key: true
end
