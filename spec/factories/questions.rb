FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new('spec/support/files/test.txt', 'text/plain') }
    end
  end
end
