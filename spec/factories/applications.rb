FactoryGirl.define do
  factory :application do
    name {FFaker::CompanyIT.name}
    package {FFaker::Internet.domain_name.reverse!}
    url {FFaker::Internet.http_url}
    icon_url {FFaker::Internet.http_url}
    latest_version {'1.0.0.1'}
    status 1
    after(:build) do |application|
      application.app_versions << FactoryGirl.build(:app_version, application: application)
    end
  end

end
