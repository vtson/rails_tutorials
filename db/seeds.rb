# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create! firstname: "Admin",
             lastname: "Admin",
             displayname:  "Admin",
             age: "20",
             gender: "1",
             email: "admin@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             admin: true,
             activated: true,
             activated_at: Time.zone.now

40.times do |n|
  firstname = Faker::Name.first_name
  lastname = Faker::Name.last_name
  age = Faker::Number.number(2)
  sex = Faker::Number.between($min = 0, $max = 3)
  displayname  = Faker::Name.name
  email = "usertest-#{n+1}@gmail.com"
  password = "password"
  User.create! firstname: firstname,
               lastname: lastname,
               displayname: displayname,
               age: age,
               gender: sex,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
end
