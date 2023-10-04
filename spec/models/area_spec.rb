# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Area, type: :model do
  describe 'rspec-parameterized' do
    describe 'overwrite trait' do
      context 'without trait' do
        let!(:static_area) { create(:area) }

        it 'static trait' do
          expect(static_area.name).to eq('日本')
        end
      end

      context 'static trait' do
        let!(:static_area) { create(:area, :tokyo) }

        it 'static trait' do
          expect(static_area.name).to eq('東京都')
        end
      end

      context 'dynamic trait with rspec-parameterized' do
        let(:trait_symbol) { nil }
        let!(:dynamic_area) { create(:area, trait_symbol) }

        where(:trait_symbol, :result) do
          [
            [:tokyo, '東京都'],
            [:okinawa, '沖縄県'],
            [nil, '日本'],  # traitを使いたくない場合は nil を渡す
          ]
        end

        with_them do
          it 'dynamic trait' do
            expect(dynamic_area.name).to eq(result)
          end
        end
      end
    end
  end
end
