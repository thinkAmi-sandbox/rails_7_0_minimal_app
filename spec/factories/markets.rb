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
FactoryBot.define do
  factory :market do
    
  end
end
