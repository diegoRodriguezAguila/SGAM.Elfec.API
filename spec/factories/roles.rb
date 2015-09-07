FactoryGirl.define do
  factory :role do
    role {"Usuario Movil"}
description {FFaker::Job.title}
status 1
  end

end
