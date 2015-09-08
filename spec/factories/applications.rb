FactoryGirl.define do
  factory :application do
    name 'Sample App'
    package {'com.sample.app'}
    url {FFaker::Internet.http_url}
    icon_url {FFaker::Internet.http_url}
    status 1
    after(:build) do |application|
      application.app_versions << FactoryGirl.build(:app_version, application: application)
    end
  end

end
