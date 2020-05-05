class Award < ApplicationRecord
  belongs_to :question
  belongs_to :recipient, class_name: 'User', optional: true

  has_one_attached :image

  validates :title, presence: true
  validates :image, file_content_type: { allow: ['image/jpeg', 'image/png'] }, if: -> { image.attached? }

  validate :validate_image_presence

  def validate_image_presence
    errors.add(:image, 'must be attached') unless image.attached?
  end
end
