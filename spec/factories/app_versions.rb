FactoryGirl.define do
  factory :app_version do
    version '1.15.08.23'
    url {FFaker::Internet.http_url}
    icon_url {FFaker::Internet.http_url}
    version_code 1
    status 1
    application
  end

end
