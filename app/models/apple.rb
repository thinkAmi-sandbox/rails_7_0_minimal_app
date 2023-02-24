# == Schema Information
#
# Table name: apples
#
#  id          :integer          not null, primary key
#  color       :integer
#  is_imported :boolean
#  name        :string
#  starts_at   :datetime
#  weight      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  area_id     :integer
#
# Indexes
#
#  index_apples_on_area_id  (area_id)
#
# Foreign Keys
#
#  area_id  (area_id => areas.id)
#
class Apple < ApplicationRecord
  belongs_to :area, optional: true

  enum color: [:yellow, :red, :green]
end
