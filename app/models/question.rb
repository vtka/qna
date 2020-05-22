class Question < ApplicationRecord
  
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :author, class_name: 'User'
  has_one :badge, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, 
                                        reject_if: :all_blank

  accepts_nested_attributes_for :badge, allow_destroy: true,
                                        reject_if: :all_blank

  validates :title, :body, presence: true

  def set_badge!(user)
    badge&.update!(user: user)
  end

  after_create :calculate_reputation
  after_create_commit :subscribe_user!

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_user!
    author.subscribe!(self)
  end
  
end
