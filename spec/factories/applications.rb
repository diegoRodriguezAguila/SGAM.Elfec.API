FactoryGirl.define do
  factory :application do
    name 'Sample App'
    version '1.2.4'
    package {'com.sample.app'}
    url {FFaker::Internet.http_url}
    icon_url {FFaker::Internet.http_url}
    status 1
  end

end
