FactoryGirl.define do
  factory :app_version do
    version '1.12.08.29'
    version_code 1
    status 1

    after(:build) do |app_version|
      app_version.application = FactoryGirl.create(:application)
    end
  end

end
