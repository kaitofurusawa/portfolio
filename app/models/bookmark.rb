class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :board

# 同じuser-boardの重複登録を防ぐ
  validates :user_id, uniqueness: { scope: :board_id }

end
