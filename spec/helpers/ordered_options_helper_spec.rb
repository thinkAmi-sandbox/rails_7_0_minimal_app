require 'rails_helper'

RSpec.describe OrderedOptionsHelper, type: :helper do
  let(:title) { RSpec.current_example.metadata[:example_group][:description] }

  context 'Hash' do
    context 'Flat' do
      context '#hash_with_string_key' do
        context '文字列を指定' do
          it '値が取得できること' do
            actual = helper.hash_with_string_key

            expect(actual['apple']).to eq('シナノゴールド')
          end
        end

        context 'シンボルを指定' do
          it '値が取得できず、nilが返ること' do
            actual = helper.hash_with_int_key

            expect(actual[:apple]).to eq(nil)
          end
        end
      end

      context '#hash_with_int_key' do
        context '数字を指定' do
          it '値が取得できること' do
            actual = helper.hash_with_int_key

            expect(actual[1]).to eq('シナノゴールド')
          end
        end

        context '文字列を指定' do
          it '値が取得できず、nilが返ること' do
            actual = helper.hash_with_int_key

            expect(actual['1']).to eq(nil)
          end
        end
      end

      context '#hash_with_symbol_key' do
        context '文字列を指定' do
          it '値が取得できず、nilが返ること' do
            actual = helper.hash_with_symbol_key

            expect(actual['apple']).to eq(nil)
          end
        end

        context 'シンボルを指定' do
          it '値が取得できること' do
            actual = helper.hash_with_symbol_key

            expect(actual[:apple]).to eq('シナノゴールド')
          end
        end
      end

      context '#hash_with_string_and_symbol_key' do
        it '文字列とシンボルで別の値が取得できること' do
          actual = helper.hash_with_string_and_symbol_key

          expect(actual['apple']).to eq('ふじ')
          expect(actual[:apple]).to eq('シナノゴールド')
        end
      end
    end
  end

  context 'ActiveSupport::InheritableOptions' do
    context 'Flat' do
      context '#inheritable_with_string_key' do
        context 'ドットアクセス' do
          it '文字列を指定しても値が取得できず、nilが返ること' do
            actual = helper.inheritable_with_string_key

            puts("#{title}: #{actual.apple.presence || 'nil'}")
            expect(actual.apple).to eq(nil)
          end
        end
      end

      context '#inheritable_with_int_key' do
        it '1を指定するとSyntaxErrorになるのでコメントアウトする' do
          actual = helper.inheritable_with_int_key

          # SyntaxError
          # no .<digit> floating literal anymore; put 0 before dot
          # expect(actual.1).to eq(nil)

          expect(1).to eq(1)
        end
      end

      context '#inheritable_with_symbol_key' do
        it '値が取得できること' do
          actual = helper.inheritable_with_symbol_key

          puts("#{title}: #{actual.apple}")
          expect(actual.apple).to eq('シナノゴールド')
        end
      end

      context '#inheritable_with_string_and_symbol_key' do
        it 'シンボルの値が取得できること' do
          actual = helper.inheritable_with_string_and_symbol_key

          puts("#{title}: #{actual.apple}")
          expect(actual.apple).to eq('シナノゴールド')
        end
      end
    end

    context 'Nested' do
      context '#nested_inheritable_with_string_key' do
        context 'ぼっち演算子を使わない' do
          it 'ネストした名前を指定するとエラーになること' do
            actual = helper.nested_inheritable_with_string_key

            expect { actual.fruit.apple.name }.to raise_error("undefined method `apple' for nil:NilClass")
          end
        end

        context 'ぼっち演算子を使う' do
          it 'ネストした名前を指定してもエラーにならず、nilが返ること' do
            actual = helper.nested_inheritable_with_string_key

            expect { actual.fruit&.apple&.name }.not_to raise_error

            expect(actual.fruit&.apple&.name).to eq(nil)
          end
        end
      end

      context '#nested_inheritable_with_symbol_key' do
        context 'ドットでアクセス' do
          it 'ネストしているものはHashのままなので、エラーになること' do
            actual = helper.nested_inheritable_with_symbol_key

            expect { actual.fruit.apple.name }.to raise_error("undefined method `apple' for {:apple=>{:name=>\"シナノゴールド\", :area=>[{:name=>\"青森県\"}, {:name=>\"長野県\"}]}}:Hash")
          end
        end

        context '一階層目はドット、それ以降はハッシュとしてアクセス' do
          it '値が取得できること' do
            actual = helper.nested_inheritable_with_symbol_key

            expect(actual.fruit[:apple][:name]).to eq('シナノゴールド')
          end
        end
      end

      context '#nested_inheritable_with_hash_transform' do
        context 'ドットでアクセス' do
          context 'チェーンの最後までHash' do
            it '値が取得できること' do
              actual = helper.nested_inheritable_with_hash_transform

              expect(actual.fruit.apple.name).to eq('シナノゴールド')
            end
          end

          context 'チェーンの途中にHash以外(Array)がある' do
            it 'Hash以外の項目がはさまるとHashのままなので、エラーになること' do
              expect do
                actual = helper.nested_inheritable_with_hash_transform
                actual.fruit.apple.area[0].name
              end.to raise_error("undefined method `name' for {:name=>\"青森県\"}:Hash")
            end
          end
        end
      end

      context '#nested_inheritable_with_hash_array_transform' do
        context 'ドットでアクセス' do
          context 'チェーンの最後までHash' do
            it '値が取得できること' do
              actual = helper.nested_inheritable_with_hash_transform

              expect(actual.fruit.apple.name).to eq('シナノゴールド')
            end
          end

          context 'チェーンの途中にHash以外(Array)がある' do
            it '値が取得できること' do
              actual = helper.nested_inheritable_with_hash_array_transform
              puts("#{title}: #{actual.fruit.apple.area}")

              expect(actual.fruit.apple.area[0].name).to eq('青森県')
            end
          end
        end
      end

      context '#nested_inheritable_with_json_parse' do
        context 'ドットでアクセス' do
          context 'チェーンの最後までHash' do
            it '値が取得できること' do
              actual = helper.nested_inheritable_with_json_parse

              expect(actual.fruit.apple.name).to eq('シナノゴールド')
            end
          end

          context 'チェーンの途中にHash以外(Array)がある' do
            it '値が取得できること' do
              actual = helper.nested_inheritable_with_json_parse
              puts("#{title}: #{actual.fruit.apple.area}")

              expect(actual.fruit.apple.area[0].name).to eq('青森県')
            end
          end
        end
      end
    end
  end
end