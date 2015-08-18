# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(admin: true,
            activated: true,
            activated_at: Time.zone.now,
            email: "admin@debatemate.com",
            password: "password",
            password_confirmation: "password",
            name: "Test Admin")

User.create(admin: false,
            activated: true,
            activated_at: Time.zone.now,
            email: "user@debatemate.com",
            password: "password",
            password_confirmation: "password",
            name: "Test User")
