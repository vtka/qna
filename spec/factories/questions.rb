FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after :create do |question|
        file_path = Rails.root.join('spec/support/files', 'test.txt')
        file = fixture_file_upload(file_path, 'file/txt')
        question.files.attach(file)
      end
    end
  end
end
