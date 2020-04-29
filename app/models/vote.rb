class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :score, presence: true
  validates_numericality_of :score, only_integer: true
end
