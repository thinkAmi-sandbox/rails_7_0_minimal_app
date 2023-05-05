# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  name       :string
#  published  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer          not null
#
# Indexes
#
#  index_blogs_on_author_id  (author_id)
#
# Foreign Keys
#
#  author_id  (author_id => authors.id)
#
FactoryBot.define do
  factory :blog do
    name { "MyString" }
    published { false }
    author { nil }
  end
end
