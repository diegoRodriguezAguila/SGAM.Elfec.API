FactoryGirl.define do
  factory :user do
    username {FFaker::Internet.user_name}
    password {FFaker::Internet.password(0, 10)}
  end

  trait   :authenticated do
    config = Rails.configuration.database_configuration[Rails.env]
    username {config['username']}
    password {config['password']}
  end

end
