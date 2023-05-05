# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Author < ApplicationRecord
  has_many :blogs
  attr_accessor :age

  def self.random_create
    rand(1..2).times do |i|
      create!(name: "Name #{i}")
    end
  end

  def update_name_with_calling_api!(after_name)
    self.name = after_name
    save!

    # 外部APIを呼んだフリ
    raise StandardError.new('bad api')
  end
end
