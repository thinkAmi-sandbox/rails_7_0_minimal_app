# == Schema Information
#
# Table name: markets
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  area_id    :integer
#
# Indexes
#
#  index_markets_on_area_id  (area_id)
#
# Foreign Keys
#
#  area_id  (area_id => areas.id)
#
class Market < ApplicationRecord
  # optional: trueにすることで #<ActiveRecord::RecordInvalid "Validation failed: Area must exist"> を防ぐ
  # 今回は area が無い場合の動作確認もしているので、optional: true の設定が必要
  belongs_to :area, optional: true

  def sell_apple?
    !!area&.apples
  end

  def sell_apple_with_present?
    area&.apples.present?
  end
end
