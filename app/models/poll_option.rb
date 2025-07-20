class PollOption < ApplicationRecord
  belongs_to :poll
  has_many :votes
  has_many :voted_users, through: :votes, source: :user

  validates :content, presence: true
end
