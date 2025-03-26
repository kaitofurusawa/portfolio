class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board

  # ▼ コメント内容は必須
  validates :content, presence: true, length: { maximum: 1000 }
end
