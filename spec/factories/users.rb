FactoryGirl.define do
  factory :user do
    username {FFaker::Internet.user_name}
    password FFaker::Internet.password(0, 10)
  end

end
