class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  validates :password, confirmation: true
  has_one_attached :profile_image
end
