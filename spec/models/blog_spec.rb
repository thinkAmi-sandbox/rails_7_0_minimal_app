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
require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'rspec_parameterized' do
    describe 'override let variables' do
      let!(:author) { create(:author) }
      let(:blog_name) { 'MyBlog' }
      let!(:blog) { create(:blog, :with_author, name: blog_name) }

      where(:blog_name, :result) do
        [
          %w[foo foo],
          %w[bar bar]
        ]
      end

      with_them do
        context 'override blog name' do
          it 'should equal override name' do
            expect(blog.name).to eq(result)
          end
        end
      end
    end

    describe 'override let! variables' do
      let!(:author) { create(:author) }
      let!(:blog) { create(:blog, name: 'MyBlog', author: author) }

      where(:blog, :result) do
        [
          [create(:blog, :with_author, name: 'taro blog'), 'taro blog'],
          [create(:blog, :with_author, name: 'hanako blog'), 'hanako blog'],

          # let! 定義したauthorを参照しようとすると、それぞれ以下のエラーになる
          # [create(:blog, author: ref(:author), name: 'jiro blog'), 'jiro blog'],
          # => ActiveRecord::AssociationTypeMismatch:
          #           Author(#9620) expected, got author which is an instance of RSpec::Parameterized::Core::RefArg(#9720)
          #
          # [create(:blog, author: lazy{ author }, name: 'jiro blog'), 'jiro blog'],
          # => ActiveRecord::AssociationTypeMismatch:
          #   Author(#9620) expected, got lazy{ author } which is an instance of RSpec::Parameterized::Core::LazyArg(#9740)

        ]
      end

      with_them do
        context 'override blog name' do
          it 'should equal override name' do
            expect(blog.name).to eq(result)
          end
        end
      end
    end
  end
end
