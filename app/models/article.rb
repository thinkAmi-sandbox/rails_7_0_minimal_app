# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  payment    :integer          default("planing"), not null
#  release    :integer          default("planing"), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  enum :payment, { planing: 0, done: 1, pending: 2 }
  # enum :release, { planing: 0, done: 1, pending: 2 }

  enum :release, { planing: 0, done: 1, pending: 2 }, prefix: true
end
