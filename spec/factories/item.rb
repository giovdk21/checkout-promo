require 'bigdecimal'

FactoryGirl.define do
  factory :item, class: OpenStruct do
    trait :item1 do
      id 1
      code '001'
      name 'Lavender heart'
      price BigDecimal.new('9.25')
    end
    trait :item2 do
      id 2
      code '002'
      name 'Personalised cufflinks'
      price BigDecimal.new('45')
    end
    trait :item3 do
      id 3
      code '003'
      name 'Kids T-shirt'
      price BigDecimal.new('19.95')
    end
  end
end
