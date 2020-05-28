FactoryBot.define do
  sequence :comment_body do |n|
    "MyComment#{n}"
  end

  factory :comment do
    body
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end

  trait :invalid_comment do
    body { nil }
  end
end
