class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :profile_image

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :email,
          presence: true,
          uniqueness: true,
          length: { maximum: 255 },
          format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('activerecord.errors.models.user.attributes.email.invalid') }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: :password_required?
  validates :profile_image,
            content_type: { in: ["image/png", "image/jpeg", "image/webp"], message: I18n.t('errors.messages.content_type_invalid') },
            size: { less_than: 5.megabytes, message: I18n.t('errors.messages.too_large', count: 5) }

  private

  def password_required?
    new_record? || !password.nil?
  end
end