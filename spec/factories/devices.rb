FactoryGirl.define do
  factory :device do
    name {'ELFEC'+(1000+rand(8999)).to_s}
    imei {Luhn.generate(16)}
    serial {FFaker::Identification.ssn}
    mac_address {(1..6).map{'%0.2X'%rand(256)}.join(':')}
    os_version '4.4.2'
    brand {FFaker::Product.brand}
    model {FFaker::Product.model}
    phone_number '72364556'
  end

end
