FactoryBot.define do
  sequence :title do |n|
    "MyTitle#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    association :author, factory: :user

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
