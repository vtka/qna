class Link < ApplicationRecord

  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url.include?('gist.github.com')
  end

  def gist_hash
    url.split('/').last
  end
end
