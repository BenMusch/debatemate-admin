User.create(admin: true,
            activated: true,
            activated_at: Time.zone.now,
            email: "admin@debatemate.com",
            password: "password",
            password_confirmation: "password",
            name: "Test Admin",
            phone: 1111111112)

User.create(admin: false,
            activated: true,
            activated_at: Time.zone.now,
            email: "user@debatemate.com",
            password: "password",
            password_confirmation: "password",
            name: "Test User",
            phone: 1111111111)

100.times do
  User.create(admin: false,
              activated: true,
              activated_at: Time.zone.now,
              name: Faker::Name.name,
              email: Faker::Internet.email,
              password: "password",
              password_confirmation: "password",
              phone: Faker::PhoneNumber.subscriber_number(10))
end

10.times do
  School.create(name: Faker::Address.city + " High School")
end

50.times do
  Lesson.create(date: Faker::Date.between(3.weeks.ago, Date.today + 10.days),
                school: School.order("RANDOM()").first)
end

Lesson.all.each do |lesson|
  users = User.order("RANDOM()")
  (rand(2) + 1).times do |i|
    lesson.goals << Goal.create(user: users[i], text: Faker::Lorem.sentence)
  end
end
