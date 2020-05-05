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

  trait :with_file do
    files { Rack::Test::UploadedFile.new('spec/support/files/test.txt', 'text/plain') }
  end
end
