FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    body
    association :author, factory: :user
    trait :invalid do
      body { nil }
    end
  
    trait :with_file do
      after :create do |answer|
        file_path = Rails.root.join('spec/support/files', 'test.txt')
        file = fixture_file_upload(file_path, 'file/txt')
        answer.files.attach(file)
      end
    end
  end
end
