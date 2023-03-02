require 'rails_helper'

RSpec.describe Apple, type: :model do
  describe '関連先の生成' do
    context '順次生成' do
      let(:area) { create(:area) }
      let(:apple) { create(:apple, area: area) }

      it do
        expect(Apple.find(apple.id).area).to eq(area)
      end
    end

    context 'factoryの継承で生成' do
      # https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#inheritance

      context 'parent指定したfactoryを使う' do
        before { create(:apple_with_parent) }

        it do
          expect(Apple.last.area.name).to eq('日本')
        end
      end

      context 'ネストしたfactoryを使う' do
        context '関連を利用' do
          context '暗黙的な定義' do
            context '関連を生成する' do
              before { create(:apple_association_by_implicit) }

              it '関連が生成されていること' do
                expect(Apple.last.area.name).to eq('日本')
              end

              it 'その他の属性は継承されていること' do
                expect(Apple.last.name).to eq('秋映')
              end
            end

            context '関連を生成しない' do
              before { create(:apple) }

              it '関連が生成されていないこと' do
                expect(Apple.last.area.blank?).to eq(true)
              end

              it 'その他の属性は継承されていること' do
                expect(Apple.last.name).to eq('秋映')
              end
            end
          end

          context '明示的な定義' do
            before { create(:apple_association_by_explicit) }

            it do
              expect(Apple.last.area.name).to eq('日本')
            end
          end

          context 'インライン定義' do
            before { create(:apple_association_by_inline) }

            it do
              expect(Apple.last.area.name).to eq('日本')
            end
          end
        end

        context 'factoryを利用' do
          context '暗黙的な定義' do
            before { create(:apple_factory_by_implicit) }

            it do
              expect(Apple.last.area.name).to eq('青森県')
            end
          end

          context '明示的な定義' do
            before { create(:apple_factory_by_explicit) }

            it do
              expect(Apple.last.area.name).to eq('長野県')
            end
          end

          context 'インライン定義' do
            before { create(:apple_factory_by_inline) }

            it do
              expect(Apple.last.area.name).to eq('岩手県')
            end
          end

          context '関連先のfactoryで定義している属性の上書き' do
            before { create(:apple_factory_with_overriding_attributes) }

            it do
              expect(Apple.last.area.name).to eq('山形県')
            end
          end
        end
      end
    end

    context 'appleのtraitで生成' do
      context 'trait 1つ' do
        before { create(:apple, :aomori_apple) }

        it do
          expect(Apple.last.area.name).to eq('青森県')
        end
      end

      context 'trait 2つ' do
        context 'createで複数traitを指定' do
          before { create(:apple, :aomori_apple, :hokkaido_apple) }

          it do
            # 後ろのtraitが適用される
            expect(Apple.count).to eq(1)
            expect(Apple.last.area.name).to eq('北海道')
          end
        end

        context 'factoryで複数traitを指定' do
          before { create(:multiple_traits) }

          it do
            # 後ろのtraitが適用される
            expect(Apple.count).to eq(1)
            expect(Apple.last.area.name).to eq('北海道')
          end
        end
      end

      context 'transientを利用' do
        context '引数なし' do
          before { create(:apple, :with_transient, name: 'フジ',) }

          it do
            actual = Apple.last

            expect(actual.area).to eq(nil)
            expect(actual.name).to eq('フジ')
          end
        end

        context '引数あり' do
          before { create(:apple, :with_transient, name: 'フジ', is_nagano: true) }

          it do
            actual = Apple.last

            expect(actual.area.name).to eq('長野県')
            expect(actual.name).to eq('シナノフジ')
          end
        end
      end
    end

    context 'factoryのcallbackで生成' do
      before { create(:callback_area) }

      it do
        expect(Apple.last.area.name).to eq('秋田県')
      end
    end
  end
end