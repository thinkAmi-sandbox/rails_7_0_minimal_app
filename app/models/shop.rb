# == Schema Information
#
# Table name: shops
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Shop < ApplicationRecord
  validates :name, presence: { message: :wrong_length, count: 4 }
  validate :validate_name

  private def validate_name
    return if name.present?

    errors.add(:name, :blank)
    errors.add(:name, :wrong_length, count: 5)
  end
end
