FactoryGirl.define do
  factory :device do
    name {FFaker::Product.product_name}
    imei {FFaker::PhoneNumber.imei}
    serial {FFaker::Identification.ssn}
    mac_address {FFaker::Internet.ip_v4_address}
    os_version '4.4.2'
    brand {FFaker::Product.brand}
    model {FFaker::Product.model}
    phone_number '72364556'
  end

end
