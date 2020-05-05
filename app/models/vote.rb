class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :direction, presence: true
  validates :user, uniqueness: { scope: %i[votable_type votable_id] }
end
