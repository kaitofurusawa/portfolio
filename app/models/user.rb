class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :profile_image

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_secure_token :password_reset_token

  # バリデーション
  validates :name, presence: true, length: { maximum: 30 }

  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('activerecord.errors.models.user.attributes.email.invalid') }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true,
            if: :validate_password?,
            allow_nil: true

  validates :profile_image,
            content_type: { in: %w[image/png image/jpeg image/webp], message: I18n.t('errors.messages.content_type_invalid') },
            size: { less_than: 5.megabytes, message: I18n.t('errors.messages.too_large', count: 5) }

  # パスワードリセット用
  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
  end

  def clear_password_reset_token!
    update!(password_reset_token: nil, password_reset_sent_at: nil)
  end

  def password_reset_token_valid?
    password_reset_sent_at && password_reset_sent_at > 2.hours.ago
  end

  private

  def validate_password?
    new_record? || password.present? || password_confirmation.present? || password_reset_token.present?
  end
end
