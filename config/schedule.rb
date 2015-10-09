evevery 1.day, :at => '9:00 am' do
  runner "User.where(admin: false).remind"
end
