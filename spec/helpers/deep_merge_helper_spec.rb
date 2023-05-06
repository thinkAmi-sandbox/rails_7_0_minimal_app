require 'rails_helper'

RSpec.describe DeepMergeHelper, type: :helper do
  describe 'Hash#merge' do
    describe '#merge_flat_hash_with_another_key' do
      it 'pass' do
        expect(merge_flat_hash_with_another_key).to eq({ name: 'foo', color: 'red' })
      end
    end

    describe '#merge_flat_hash_with_same_key' do
      it 'pass' do
        expect(merge_flat_hash_with_same_key).to eq({ name: 'bar' })
      end
    end

    describe '#merge_nested_hash_with_another_key' do
      it 'pass' do
        expect(merge_nested_hash_with_another_key).to eq({ name: { sweet_potato: 'シルクスイート' } })
      end
    end

    describe '#merge_nested_hash_with_same_key' do
      it 'pass' do
        expect(merge_nested_hash_with_same_key).to eq({ name: { apple: '秋映' } })
      end
    end

    describe '#merge_flat_hash_with_string_and_symbol' do
      it 'pass' do
        expect(merge_flat_hash_with_string_and_symbol).to eq({ name: 'foo', 'name' => 'bar' })
      end
    end

    describe '#merge_nested_hash_with_string_and_symbol' do
      it 'pass' do
        expect(merge_nested_hash_with_string_and_symbol).to eq({ name: { 'apple' => '秋映' } })
      end
    end
  end

  describe 'ActiveSupport#deep_merge' do
    describe '#deep_merge_flat_hash_with_another_key' do
      it 'pass' do
        expect(deep_merge_flat_hash_with_another_key).to eq({ name: 'foo', color: 'red' })
      end
    end

    describe '#deep_merge_flat_hash_with_same_key' do
      it 'pass' do
        expect(deep_merge_flat_hash_with_same_key).to eq({ name: 'bar' })
      end
    end

    describe '#deep_merge_nested_hash_with_another_key' do
      it 'pass' do
        expect(deep_merge_nested_hash_with_another_key).to eq({ name: { apple: 'シナノゴールド', sweet_potato: 'シルクスイート' } })
      end
    end

    describe '#deep_merge_nested_hash_with_same_key' do
      it 'pass' do
        expect(deep_merge_nested_hash_with_same_key).to eq({ name: { apple: '秋映' } })
      end
    end

    describe '#deep_merge_flat_hash_with_string_and_symbol' do
      it 'pass' do
        expect(deep_merge_flat_hash_with_string_and_symbol).to eq({ name: 'foo', 'name' => 'bar' })
      end
    end

    describe '#deep_merge_nested_hash_with_string_and_symbol' do
      it 'pass' do
        expect(deep_merge_nested_hash_with_string_and_symbol).to eq({ name: { apple: 'シナノゴールド', 'apple' => '秋映' } })
      end
    end
  end

  describe 'ActiveSupport#deep_merge + #with_indifferent_access' do
    describe '#deep_merge_flat_hash_with_indifferent_access' do
      it 'pass' do
        # 実際には、 #<HashWithIndifferentAccess { 'name' => 'bar' }> になっている
        expect(deep_merge_flat_hash_with_indifferent_access).to eq({ 'name' => 'bar' })
      end
    end

    describe '#deep_merge_nested_hash_with_indifferent_access' do
      it 'pass' do
        # 実際には、#<HashWithIndifferentAccess { "name" => #<HashWithIndifferentAccess { "apple" => "秋映" }> }> になっている
        expect(deep_merge_nested_hash_with_indifferent_access).to eq({ 'name' => { 'apple' => '秋映' } })
      end
    end
  end

  describe 'ActiveSupport#deep_merge + block' do
    describe '#deep_merge_flat_hash_with_block' do
      it 'pass' do
        expect(deep_merge_flat_hash_with_block).to eq({ name: 'foobar' })
      end
    end

    describe '#deep_merge_nested_hash_with_block' do
      it 'pass' do
        expect(deep_merge_nested_hash_with_block).to eq({ name: { apple: 'key: apple > シナノゴールド and 秋映' }})
      end
    end

    describe '#deep_merge_increment_with_block' do
      it 'pass' do
        expect(deep_merge_increment_with_block).to eq({ amount: { apple: 300, sweet_potato: 50 }})
      end
    end

    describe 'if-else eq deep_merge' do
      it 'pass' do
        expect(hash_with_if_else).to eq(hash_with_deep_merge)
      end
    end
  end

  describe 'ActiveSupport#deep_merge + block + #with_indifferent_access' do
    describe '#deep_merge_increment_with_block_and_indifferent_access' do
      it 'pass' do
        # 実際は #<HashWithIndifferentAccess { "amount" => #<HashWithIndifferentAccess { "apple" => 300, "sweet_potato" => 50 }> }>
        expect(deep_merge_increment_with_block_and_indifferent_access).to eq({ 'amount' => { 'apple' => 300, 'sweet_potato' => 50 }})
      end
    end
  end
end