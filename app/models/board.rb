class Board < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }

  validates :image,
            content_type: { in: ["image/png", "image/jpeg", "image/webp"], message: I18n.t('errors.messages.content_type_invalid') },
            size: { less_than: 5.megabytes, message: I18n.t('errors.messages.too_large', count: 5) }
end
