# == Schema Information
#
# Table name: robots
#
#  id         :integer          not null, primary key
#  name       :string
#  note       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :robot do
    name { "MyString" }
  end
end
