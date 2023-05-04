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
require 'rails_helper'

RSpec.describe Favorite, type: :model do
  context 'change matcher with compound matcher expressions' do
    it 'pass' do
      favorite = Favorite.create!(name: '秋映', is_secret: true)

      expect {
        Favorite.find(favorite.id).update!(name: 'シナノゴールド', is_secret: false)
        favorite.reload
      }.to change { favorite.name }.to('シナノゴールド').and change { favorite.is_secret }.to(false)
    end
  end

  context 'change matcher with have_attributes' do
    pending 'raise error as of 3.12.2' do
      # https://github.com/rspec/rspec-expectations/issues/1131
      it 'error' do
        favorite = Favorite.create!(name: '秋映', is_secret: true)

        # expected `favorite` to have changed to
        # #<RSpec::Matchers::BuiltIn::HaveAttributes:0x00007f02f5d99e10 @actual=nil,
        #   @expected={ name: "シナノゴールド", is_secret: false }, @negated=false, @respond_to_failed=false, @values={}>,
        # but did not change
        expect {
          Favorite.find(favorite.id).update!(name: 'シナノゴールド', is_secret: false)
          favorite.reload
        }.to change { favorite }.to have_attributes(name: 'シナノゴールド', is_secret: false)
      end
    end

    context 'pass as of 3.12.2' do
      pending 'attributes + a_hash_including' do
        # expected `favorite.attributes` to have changed to
        # #<a hash including (name: "シナノゴールド", is_secret: false)>,
        # but is now { "id" => 1, "name" => "シナノゴールド", "is_secret" => false,
        # "created_at" => #<ActiveSupport::TimeWithZone 2023-05-04 16:54:13+(436697/1000000) +09:00 (JST)>,
        # "updated_at" => #<ActiveSupport::TimeWithZone 2023-05-04 16:54:13+(445287/1000000) +09:00 (JST)> }
        it 'error' do
          favorite = Favorite.create!(name: '秋映', is_secret: true)

          expect {
            Favorite.find(favorite.id).update!(name: 'シナノゴールド', is_secret: false)
            favorite.reload
          }.to change{
            favorite.attributes
          }.to a_hash_including(name: 'シナノゴールド', is_secret: false)
        end
      end

      context 'attributes + with_indifferent_access + a_hash_including' do
        it 'pass' do
          favorite = Favorite.create!(name: '秋映', is_secret: true)

          expect {
            Favorite.find(favorite.id).update!(name: 'シナノゴールド', is_secret: false)
            favorite.reload
          }.to change{
            favorite.attributes.with_indifferent_access
          }.to a_hash_including(name: 'シナノゴールド', is_secret: false)
        end
      end

      context 'dup + have_attributes' do
        it 'pass' do
          favorite = Favorite.create!(name: '秋映', is_secret: true)

          expect {
            Favorite.find(favorite.id).update!(name: 'シナノゴールド', is_secret: false)
            favorite.reload
          }.to change{
            favorite.dup
          }.to have_attributes(name: 'シナノゴールド', is_secret: false)
        end
      end
    end
  end
end
