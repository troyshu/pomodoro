namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    #create pomodoros for some users
    
    # users = User.all(limit: 6)
    # count = 0
    # 50.times do
    #   users.each { |user| user.pomodoros.create!(length: 25, finished: true) }
    # end

    #create pomodoros: random number for the past year
    users = User.all(limit:1)
    total = 365
    count = 0
    total.times do 
      
      
      users.each do |user|
        random_number = rand(12)
        random_number.times do
          break if count > 90
          user.pomodoros.create!(length: 25, finished: true, updated_at: count.day.ago, created_at: count.day.ago)
          count = count + 1
          
        end
      end

    end

  end
end