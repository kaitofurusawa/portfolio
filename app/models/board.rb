class Board < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  # 投稿バリデーション
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }

  validates :image,
  content_type: ['image/png', 'image/jpeg', 'image/webp'],
  size: { less_than: 5.megabytes, message: 'は5MB以内の画像にしてください' }

end
