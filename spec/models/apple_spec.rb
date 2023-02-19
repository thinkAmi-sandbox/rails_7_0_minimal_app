# == Schema Information
#
# Table name: apples
#
#  id          :integer          not null, primary key
#  color       :integer
#  is_imported :boolean
#  name        :string
#  starts_at   :datetime
#  weight      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  area_id     :integer
#
# Indexes
#
#  index_apples_on_area_id  (area_id)
#
# Foreign Keys
#
#  area_id  (area_id => areas.id)
#
require 'rails_helper'

RSpec.describe Apple, type: :model do
  # area
  let!(:aomori) { create(:area, name: '青森県') }
  let!(:nagano) { create(:area, name: '長野県') }
  let!(:america) { create(:area, name: 'アメリカ') }
  let!(:australia) { create(:area, name: 'オーストラリア') }
  let!(:uk) { create(:area, name: 'イギリス') }

  # apple
  let!(:shinano_dolce) { create(:apple, :red, :mid_sep, name: 'シナノドルチェ', area: nagano) }
  let!(:akibae) { create(:apple, :red, :mid_oct, name: '秋映', area: nagano) }
  let!(:shinano_gold) { create(:apple, :yellow, :late_oct, name: 'シナノゴールド', weight: 350, area: nagano) }
  let!(:tsugaru) { create(:apple, :red, :early_sep, name: 'つがる', area: aomori) }
  let!(:fuji) { create(:apple, :red, :early_nov, name: 'ふじ', area: aomori) }


  describe 'sort' do
    # https://qiita.com/YumaInaura/items/ddaffb8cbc719ea4326f
    before do
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    context 'sort by SQL' do
      context 'single key' do
        context 'single table' do
          context 'ascending (default)' do
            it do
              actual = Apple.order(:starts_at).to_a

              expect(actual).to eq([tsugaru, shinano_dolce, akibae, shinano_gold, fuji])
            end
          end

          context 'descending' do
            it do
              actual = Apple.order(starts_at: :desc).to_a

              expect(actual).to eq([fuji, shinano_gold, akibae, shinano_dolce, tsugaru])
            end
          end
        end

        context 'multiple tables' do
          context 'メソッドを使い、文字列を指定' do
            it do
              actual = Apple.joins(:area).order('areas.name DESC').to_a

              expect(actual).to eq([tsugaru, fuji,  shinano_dolce, akibae, shinano_gold])
            end
          end

          context 'mergeメソッドを使う' do
            it do
              actual = Apple.joins(:area).merge(Area.order(name: :desc)).to_a

              expect(actual).to eq([tsugaru, fuji,  shinano_dolce, akibae, shinano_gold])
            end
          end
        end
      end

      context 'multiple keys' do
        context 'single table' do
          it do
            actual = Apple.order(name: :asc, starts_at: :desc).to_a

            expect(actual).to eq([tsugaru, fuji, shinano_gold, shinano_dolce, akibae])
          end
        end

        context 'multiple tables' do
          # 秋映と同じ時期の青森県育成りんごを追加
          let!(:tsugaru_gold) { create(:apple, :yellow, :mid_sep, name: '津軽ゴールド', area: aomori) }

          context 'appleのstarts_atの降順 > areaのnameの降順でソート' do
            it do
              actual = Apple.joins(:area).order(starts_at: :desc).merge(Area.order(name: :desc)).to_a

              expect(actual).to eq([fuji, shinano_gold, akibae, tsugaru_gold, shinano_dolce, tsugaru])
            end
          end

          context 'areaのnameの降順 > appleのstarts_atの降順でソート' do
            it do
              actual = Apple.joins(:area).merge(Area.order(name: :desc)).order(starts_at: :desc).to_a

              expect(actual).to eq([fuji, tsugaru_gold, tsugaru, shinano_gold, akibae, shinano_dolce])
            end
          end
        end
      end
    end

    context 'sort by Ruby' do
      context 'single key' do
        context 'single table' do
          let(:apples) { Apple.all.to_a }

          context 'string attribute' do
            context 'ascending' do
              it do
                actual = apples.sort_by(&:name)

                expect(actual).to eq([tsugaru, fuji, shinano_gold, shinano_dolce, akibae])
              end
            end

            context 'descending' do
              it do
                # actual = apples.sort_by { |a| -(a.name) } => NG
                actual = apples.sort_by(&:name).reverse

                expect(actual).to eq([akibae, shinano_dolce, shinano_gold, fuji, tsugaru])
              end
            end
          end

          context 'integer attribute' do
            context 'ascending' do
              it do
                actual = apples.sort_by(&:weight)

                expect(actual).to eq([shinano_dolce, akibae, tsugaru, fuji, shinano_gold])
              end
            end

            context 'descending' do
              it do
                actual = apples.sort_by { |a| -a.weight }

                expect(actual).to eq([shinano_gold, shinano_dolce, akibae, tsugaru, fuji])
              end
            end
          end

          context 'enum attribute' do
            let!(:bramley) { create(:apple, :green, :mid_sep, name: 'ブラムリー', area: uk) }

            context 'attribute' do
              context 'ascending (default)' do
                it do
                  actual = apples.sort_by(&:color)

                  # green -> red -> yellow
                  expect(actual).to eq([bramley, shinano_dolce, akibae, tsugaru, fuji, shinano_gold])
                end
              end

              context 'descending' do
                it do
                  actual = apples.sort_by { |a| a.color }.reverse

                  # yellow -> red -> green
                  expect(actual).to eq([shinano_gold, fuji, tsugaru, akibae, shinano_dolce, bramley])
                end
              end
            end

            context 'before_type_cast' do
              context 'ascending (default)' do
                it do
                  actual = apples.sort_by(&:color_before_type_cast)

                  # yellow (1) -> red (2) -> green (3)
                  expect(actual).to eq([shinano_gold, shinano_dolce, akibae, tsugaru, fuji, bramley])
                end
              end

              context 'descending' do
                it do
                  actual = apples.sort_by { |a| -(a.color_before_type_cast) }

                  # green (3) -> red (2) -> yellow (1)
                  expect(actual).to eq([bramley, shinano_dolce, akibae, tsugaru, fuji, shinano_gold])
                end
              end
            end
          end

          context 'datetime attribute' do
            context 'ascending' do
              it do
                actual = apples.sort_by(&:starts_at)

                expect(actual).to eq([tsugaru, shinano_dolce, akibae, shinano_gold, fuji])
              end
            end

            context 'descending' do
              it do
                # NoMethodError: undefined method `-@'
                # for Sun, 10 Sep 2023 00:00:00.000000000 JST +09:00:ActiveSupport::TimeWithZone
                # actual = apples.sort_by { |a| -(a.starts_at) }
                #
                # convert to unix timestamp
                # https://api.rubyonrails.org/classes/DateTime.html#method-i-to_i
                actual = apples.sort_by { |a| -(a.starts_at.to_i) }

                expect(actual).to eq([fuji, shinano_gold, akibae, shinano_dolce, tsugaru])
              end
            end
          end

          context 'boolean attribute' do
            let!(:pink_lady) do
              create(:apple, :red, :late_nov, name: 'ピンクレディ', weight: 250, is_imported: true, area: australia)
            end

            context 'true -> false の順に並べる' do
              it do
                # comparison of FalseClass with true failed
                # actual = apples.sort_by { |a| a.is_imported }
                actual = apples.sort_by { |a| a.is_imported ? 0 : 1 }

                expect(actual).to eq([pink_lady, shinano_dolce, akibae, shinano_gold, tsugaru, fuji])
              end
            end

            context 'false -> true の順に並べる' do
              it do
                actual = apples.sort_by { |a| a.is_imported ? 1 : 0 }

                expect(actual).to eq([shinano_dolce, akibae, shinano_gold, tsugaru, fuji, pink_lady])
              end
            end
          end

          context 'foreign key' do
            let!(:pink_lady) do
              create(:apple, :red, :late_nov, name: 'ピンクレディ', weight: 250, is_imported: true, area: australia)
            end
            let(:apples) { Apple.eager_load(:area).all.to_a }

            context 'ascending' do
              it do
                actual = apples.sort_by { |a| a.area.id }

                expect(actual).to eq([tsugaru, fuji, shinano_dolce, akibae, shinano_gold, pink_lady])
              end
            end

            context 'descending' do
              it do
                actual = apples.sort_by { |a| -(a.area.id) }

                expect(actual).to eq([pink_lady, shinano_dolce, akibae, shinano_gold, tsugaru, fuji])
              end
            end
          end
        end

        context 'multiple attributes (enum & string)' do
          let(:apples) { Apple.all.to_a }

          # シナノゴールドと同じ色のりんごを追加
          let!(:tsugaru_gold) { create(:apple, :yellow, :mid_sep, name: '津軽ゴールド', area: aomori) }

          context 'ascending(色) -> ascending(名前)' do
            it do
              actual = apples.sort_by { |a| [a.color_before_type_cast, a.name] }

              expect(actual).to eq([shinano_gold, tsugaru_gold, tsugaru, fuji, shinano_dolce, akibae])
            end
          end

          context 'descending(色) -> descending(名前)' do
            it do
              actual = apples.sort_by { |a| [a.color_before_type_cast, a.name] }.reverse

              expect(actual).to eq([akibae, shinano_dolce, fuji, tsugaru, tsugaru_gold, shinano_gold])
            end
          end

          context 'ascending(色) -> descending(名前)' do
            it 'sortを使う' do
              # https://stackoverflow.com/questions/16628699/sorting-multiple-values-by-ascending-and-descending
              actual = apples.sort do |a, b|
                [a.color_before_type_cast, b.name] <=> [b.color_before_type_cast, a.name]
              end

              expect(actual).to eq([tsugaru_gold, shinano_gold, akibae, shinano_dolce, fuji, tsugaru])
            end
          end

          context 'descending(色) -> ascending(名前)' do
            it 'sortを使う' do
              actual = apples.sort do |a, b|
                [b.color_before_type_cast, a.name] <=> [a.color_before_type_cast, b.name]
              end

              # 色が red -> yellow、同じ色の中ではひらがな -> カタカナ -> 漢字 順
              expect(actual).to eq([tsugaru, fuji, shinano_dolce, akibae, shinano_gold, tsugaru_gold])
            end
          end
        end
      end
    end
  end
end
