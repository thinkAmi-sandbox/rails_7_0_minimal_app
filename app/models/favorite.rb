# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  is_secret  :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Favorite < ApplicationRecord
end
