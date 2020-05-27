# frozen_string_literal: true

ThinkingSphinx::Index.define :question, with: :active_record do
  # indexed fields
  indexes title, sortable: true
  indexes body
  indexes author.email, as: :author, sortable: true

  # attributes
  has author_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
