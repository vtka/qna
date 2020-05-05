FactoryBot.define do
  sequence :question_title do |n|
    "Question#{n}"
  end

  factory :question do
    title { generate(:question_title) }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new('spec/support/files/test.txt', 'text/plain') }
    end
  end
end
