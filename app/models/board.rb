class Board < ApplicationRecord
  belongs_to :user
  has_one_attached :image # 何切る画像用のカラム
end
