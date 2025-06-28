class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :profile_image

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_boards, through: :bookmarks, source: :board
  has_many :votes
  has_many :voted_poll_options, through: :votes, source: :poll_option

  has_secure_token :reset_password_token

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

  validates :provider, uniqueness: { scope: :uid }, allow_blank: true

  # パスワードリセット用
  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.zone.now
    save!(validate: false)
  end

  def clear_reset_password_token!
    update!(reset_password_token: nil, reset_password_sent_at: nil)
  end

  def reset_password_token_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end

  private

  def validate_password?
    new_record? || password.present? || password_confirmation.present? || reset_password_token.present?
  end
end
