module DeepMergeHelper
  # ----------------------------------------
  # Hash#merge
  # ----------------------------------------
  def merge_flat_hash_with_another_key
    h1 = { name: 'foo' }
    h2 = { color: 'red' }

    h1.merge(h2)
  end

  def merge_flat_hash_with_same_key
    h1 = { name: 'foo' }
    h2 = { name: 'bar' }

    h1.merge(h2)
  end

  def merge_nested_hash_with_another_key
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      sweet_potato: 'シルクスイート'
    } }

    h1.merge(h2)
  end

  def merge_nested_hash_with_same_key
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      apple: '秋映',
    } }

    h1.merge(h2)
  end

  def merge_flat_hash_with_string_and_symbol
    h1 = { name: 'foo' }
    h2 = { 'name' => 'bar' }

    h1.merge(h2)
  end

  def merge_nested_hash_with_string_and_symbol
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      'apple' => '秋映',
    } }

    h1.merge(h2)
  end

  # ----------------------------------------
  # ActiveSupport#deep_merge
  # ----------------------------------------
  def deep_merge_flat_hash_with_another_key
    h1 = { name: 'foo' }
    h2 = { color: 'red' }

    h1.deep_merge(h2)
  end

  def deep_merge_flat_hash_with_same_key
    h1 = { name: 'foo' }
    h2 = { name: 'bar' }

    h1.deep_merge(h2)
  end

  def deep_merge_nested_hash_with_another_key
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      sweet_potato: 'シルクスイート'
    } }

    h1.deep_merge(h2)
  end

  def deep_merge_nested_hash_with_same_key
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      apple: '秋映',
    } }

    h1.deep_merge(h2)
  end

  def deep_merge_flat_hash_with_string_and_symbol
    h1 = { name: 'foo' }
    h2 = { 'name' => 'bar' }

    h1.deep_merge(h2)
  end

  def deep_merge_nested_hash_with_string_and_symbol
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      'apple' => '秋映',
    } }

    h1.deep_merge(h2)
  end

  # ----------------------------------------
  # ActiveSupport#deep_merge + #with_indifferent_access
  # ----------------------------------------
  def deep_merge_flat_hash_with_indifferent_access
    h1 = { name: 'foo' }
    h2 = { 'name' => 'bar' }

    h1.with_indifferent_access.deep_merge(h2)
  end

  def deep_merge_nested_hash_with_indifferent_access
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      'apple' => '秋映',
    } }

    h1.with_indifferent_access.deep_merge(h2)
  end

  # ----------------------------------------
  # ActiveSupport#deep_merge + block
  # ----------------------------------------
  def deep_merge_flat_hash_with_block
    h1 = { name: 'foo' }
    h2 = { name: 'bar' }

    h1.deep_merge(h2) do |_key, this_val, other_val|
      this_val + other_val
    end
  end

  def deep_merge_nested_hash_with_block
    h1 = { name: {
      apple: 'シナノゴールド',
    } }
    h2 = { name: {
      apple: '秋映',
    } }

    h1.deep_merge(h2) do |key, this_val, other_val|
      "key: #{key} > #{this_val} and #{other_val}"
    end
  end

  def deep_merge_increment_with_block
    h1 = { amount: {
      apple: 100,
      sweet_potato: 50
    } }
    h2 = { amount: {
      apple: 200,
    } }

    h1.deep_merge(h2) do |_key, this_val, other_val|
      this_val + other_val
    end
  end

  def hash_with_if_else
    result = {}

    [{ apple: 100 }, { sweet_potato: 50}, { apple: 200 }].each do |item|
      item.each do |k, v|
        if result.has_key?(k)
          result[k] += v
        else
          result[k] = v
        end
      end
    end
  end

  def hash_with_deep_merge
    result = {}

    [{ apple: 100 }, { sweet_potato: 50}, { apple: 200 }].each do |item|
      result.deep_merge(item) { |_key, this_val, other_val| this_val + other_val }
    end
  end

  # ----------------------------------------
  # ActiveSupport#deep_merge + block + #with_indifferent_access
  # ----------------------------------------
  def deep_merge_increment_with_block_and_indifferent_access
    h1 = { amount: {
      apple: 100,
      sweet_potato: 50
    } }
    h2 = { amount: {
      'apple' => 200,
    } }

    h1.with_indifferent_access.deep_merge(h2) do |_key, this_val, other_val|
      this_val + other_val
    end
  end
end