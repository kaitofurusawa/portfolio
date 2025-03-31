class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board

  validates :content, presence: true, length: { maximum: 5000 }
end
