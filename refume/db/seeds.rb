# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

country_arr = ["Italy", "Iraq", "India", "Turkey", "China", "Iraq"]
goals_arr = ["I want to start my own company.", "Set aside money for my children's education.", "I hope to buy a big house.", "Get my dream car.", "I hope I can star in a movie someday.", "Some day, I hope to be an astronaut and fly to the moon in a SpaceX rocket."]
language_arr = ["English,Spanish,Italian,German", "Arabic", "Hindi,English,Tamil",  "Turkish,English", "Mandarin,Cantonese,English", "English,Arabic"]
bio_arr = ["My family is very important to me, and I grew up living with three sisters and a brother.", "I am 20 year old interested in technology, IT and computer science.", "I like eating Indian food and watching Bollywood movies. I spent three years learning how to dance.", "I play the guitar and enjoy discovering new musicians online. I also like computers.", "I have lived in China my entire life. I like to read books in my free time.", "I enjoy reading astrophysics books and watching astrophysics videos online."]

6.times do |n|
    name  = Faker::Name.name
    email = "stewart.dulaney-#{n+1}@gmail.com"
    password = User.digest("password")
    User.create!(name:  name,
                 email: email,
                 age: n+1,
                 zipcode: 90024,
                 phone: "(123) 345-6789",
                 country: country_arr[n],
                 goals: goals_arr[n],
                 password_digest:       password,
                 language: language_arr[n],
                 bio: bio_arr[n],
                 role: n < 4 ? "Mentee" : "Mentor",
                 activated: true)
  end

=begin
  4.times do |n|
    Match.create!(mentee_id: n+1,
                 mentor_id: (n+1).even? ? 5 : 6)
  end
=end

## testing
User.create!(name: 'one', email: 'one@gmail.com',password: User.digest("012340"),
              age: 33, zipcode: 90024, phone:"(123) 345-6789", language: 'English,Spanish,Italian,German',
              country: 'Italy', goals: 'I hope to buy a big house',
              bio:'I like eating Indian food and watching Bollywood movies. I spent three years learning how to dance.',
              role: 'Mentor', activated: true)

User.create!(name: 'two', email: 'two@gmail.com', password: User.digest("012340"),
                age: 33, zipcode: 90024, phone:"(123) 345-6789", language: 'Mandarin,Cantonese,English',
                country: 'China', goals: 'I hope to buy a big house',
                bio:'I spent three years learning how to dance. And I like Chinese food.',
                role: 'Mentor', activated: true)

# Sample data for discussion forum
Category.create!(name: "Education")
Post.create!(content: "Does anyone know the most economical English courses in Westwood?", user_id: 1, category_id: 1)
Post.create!(content: "Where can I find out a list of K-12 schools near Santa Monica?", user_id: 1, category_id: 1)
Post.create!(content: "Is Santa Monica College a good option for transferring to UCLA?", user_id: 1, category_id: 1)
Post.create!(content: "Who can take courses at UCLA Extension?", user_id: 1, category_id: 1)
Post.create!(content: "Are there any free English courses around LA?", user_id: 1, category_id: 1)