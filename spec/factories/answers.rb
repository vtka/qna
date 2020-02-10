FactoryBot.define do
  factory :answer do
    title { "MyString" }
    string { "MyString" }
    body { "MyText" }
    question { nil }
  end
end
