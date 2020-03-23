FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    body
  end

  trait :invalid do
    body { nil }
  end
end
