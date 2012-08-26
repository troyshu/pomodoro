FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
		user_level 5
    end
  end

  factory :pomodoro do
    finished false
    length 0

    factory :finished_pomodoro do
    	finished true
    	length 25
    end

  	user
  end


end