class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :profile_image

  # 👇 ここ追加！
  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: :password_required?

  private

  def password_required?
    new_record? || !password.nil?
  end
end
