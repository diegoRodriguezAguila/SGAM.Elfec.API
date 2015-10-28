FactoryGirl.define do
  factory :application do
    name {FFaker::CompanyIT.name}
    package {FFaker::Internet.domain_name.reverse!}
    latest_version {'1.0.0.1'}
    status 1
  end

end
