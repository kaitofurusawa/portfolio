class Poll < ApplicationRecord
  belongs_to :board
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, allow_destroy: true

  validates :question, presence: true, if: -> { poll_options.size > 0 }
  validate :must_have_at_least_two_options, if: -> { question.present? }

  def must_have_at_least_two_options
    valid_options = poll_options.reject { |opt| opt.marked_for_destruction? || opt.content.blank? }
    if valid_options.size < 2
      # questionにもエラー追加
      errors.add(:question, I18n.t("polls.errors.at_least_two_options"))
      # もしくはbaseにも同時に付けてもOK
      #errors.add(:base, I18n.t("polls.errors.at_least_two_options"))
    end
  end
end
