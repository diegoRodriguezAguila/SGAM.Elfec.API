FactoryGirl.define do
  factory :device do
    name {'ELFEC'+(1000+rand(8999)).to_s}
    imei {Luhn.generate(16)}
    serial {FFaker::Identification.ssn}
    wifi_mac_address {(1..6).map{'%0.2X'%rand(256)}.join(':')}
    bluetooth_mac_address {(1..6).map{'%0.2X'%rand(256)}.join(':')}
    os_version '4.4.2'
    baseband_version {FFaker::Identification.ssn}
    brand {FFaker::Product.brand}
    model {FFaker::Product.model}
    phone_number '72364556'
    gmail_account {FFaker::Internet.email}
  end

end
