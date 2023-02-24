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
require 'rails_helper'

RSpec.describe Market, type: :model do
  describe '挙動確認' do
    context '!や!!の確認' do
      let!(:market) { create(:market, area: nil) }

      context '取得しただけ' do
        # itの中身がわかりやすいので、itの説明は省略(以降同様)
        it do
          actual = Market.find(market.id)

          expect(actual).to eq(market)
        end
      end

      context '!(否定)' do
        it do
          actual = Market.find(market.id)

          expect(!actual).to eq(false)
        end
      end

      context '!!(二重否定)' do
        it do
          actual = Market.find(market.id)

          expect(!!actual).to eq(true)
        end
      end
    end

    context '&.と組み合わせた、!や!!の確認' do
      context '多対一での確認(market : area = n : 1)' do
        context 'marketのみあり' do
          let!(:market) { create(:market, area: nil) }

          context '&.' do
            it do
              actual = Market.find(market.id)

              expect(actual&.area).to eq(nil)
            end
          end

          context '!&.' do
            it do
              actual = Market.find(market.id)

              expect(!actual&.area).to eq(true)
            end
          end

          context '!!&.' do
            it do
              actual = Market.find(market.id)

              expect(!!actual&.area).to eq(false)
            end
          end

          context 'present?' do
            it do
              actual = Market.find(market.id)

              expect(actual.area.present?).to eq(false)
            end
          end
        end

        context 'marketとareaともにあり' do
          let!(:area) { create(:area) }
          let!(:market) { create(:market, area: area) }

          context '&.' do
            it do
              actual = Market.find(market.id)

              expect(actual&.area).to eq(area)
            end
          end

          context '!&.' do
            it do
              actual = Market.find(market.id)

              expect(!actual&.area).to eq(false)
            end
          end

          context '!!&.' do
            it do
              actual = Market.find(market.id)

              expect(!!actual&.area).to eq(true)
            end
          end

          context 'present?' do
            it do
              actual = Market.find(market.id)

              expect(actual.area.present?).to eq(true)
            end
          end
        end
      end
    end

    context '一対多での確認(area : apple = 1 : n)' do
      context 'areaのみあり' do
        let!(:area) { create(:area) }

        context '&.' do
          it do
            actual = Area.find(area.id)

            # 左辺: #<ActiveRecord::Relation []>
            expect(actual&.apples).to eq([])
          end
        end

        context '!&.' do
          it do
            actual = Area.find(area.id)

            expect(!actual&.apples).to eq(false)
          end
        end

        context '!!&.' do
          it do
            actual = Area.find(area.id)

            expect(!!actual&.apples).to eq(true)
          end
        end

        context 'present?' do
          it do
            actual = Area.find(area.id)

            expect(actual.apples.present?).to eq(false)
          end
        end
      end

      context 'areaとappleともにあり' do
        let!(:area) { create(:area) }
        let!(:apple) { create(:apple, area: area)}

        context '&.' do
          it do
            actual = Area.find(area.id)

            expect(actual&.apples).to eq([apple])
          end
        end

        context '!&.' do
          it do
            actual = Area.find(area.id)

            expect(!actual&.apples).to eq(false)
          end
        end

        context '!!&.' do
          it do
            actual = Area.find(area.id)

            expect(!!actual&.apples).to eq(true)
          end
        end

        context 'present?' do
          it do
            actual = Area.find(area.id)

            expect(actual.apples.present?).to eq(true)
          end
        end
      end
    end
  end

  describe '#sell_apple?' do
    context 'Marketのみあり' do
      let!(:actual) { create(:market, area: nil) }

      it do
        expect(actual.sell_apple?).to eq(false)
        expect(actual.sell_apple_with_present?).to eq(false)
      end
    end

    context 'MarketとAreaあり' do
      context 'area without apple' do
        let!(:area) { create(:area) }
        let!(:actual) { create(:market, area: area) }

        it do
          expect(actual.sell_apple?).to eq(true)
          expect(actual.sell_apple_with_present?).to eq(false)
        end
      end
    end

    context 'MarketとAreaとAppleあり' do
      let!(:area) { create(:area) }
      let!(:apple) { create(:apple, area: area)}
      let!(:actual) { create(:market, area: area) }

      it do
        expect(actual.sell_apple?).to eq(true)
        expect(actual.sell_apple_with_present?).to eq(true)
      end
    end
  end
end
