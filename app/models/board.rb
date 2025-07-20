class Board < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_one_attached :image
  has_one :poll, dependent: :destroy
  accepts_nested_attributes_for :poll, allow_destroy: true

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :image,
            content_type: { in: [ "image/png", "image/jpeg", "image/webp" ], message: I18n.t("errors.messages.content_type_invalid") },
            size: { less_than: 5.megabytes, message: I18n.t("errors.messages.too_large", count: 5) }
end
