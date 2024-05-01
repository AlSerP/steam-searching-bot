Favorite.all.each do |fav|
  next if fav.chat_id.nil?
  next unless fav.user.nil?

  user = User.find_by(tg_id: fav.chat_id)
  user ||= User.create!(tg_id: fav.chat_id)

  fav.user = user
  fav.save!
end
