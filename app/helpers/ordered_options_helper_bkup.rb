require 'ostruct'

module OrderedOptionsHelper
  # Hash
  ## flat
  def hash_with_string_key
    { 'apple' => 'シナノゴールド' }
  end

  def hash_with_int_key
    { 1 => 'シナノゴールド' }
  end

  def hash_with_symbol_key
    { apple: 'シナノゴールド' }
  end

  def hash_with_string_and_symbol_key
    {
      'apple' => 'ふじ',
      apple: 'シナノゴールド'
    }
  end

  ## nested
  def nested_hash_with_string_key
    {
      'fruit' => {
        'apple' => {
          'name' => 'シナノゴールド',
          'area' => [
            { 'name' => '青森県' },
            { 'name' => '長野県' },
          ]
        }
      }
    }
  end

  def nested_hash_with_int_key
    { 1 => {
        2 => {
          3 => 'シナノゴールド',
          4 => [
            { 5 => '青森県' },
            { 5 => '長野県' }
          ]
        }
      }
    }
  end

  def nested_hash_with_symbol_key
    {
      fruit: {
        apple:  {
          name: 'シナノゴールド',
          area: [
            { name: '青森県' },
            { name: '長野県' },
          ]
        }
      }
    }
  end

  # ActiveSupport::OrderedOptions
  ## flat
  def ordered_with_string_key
    h = ActiveSupport::OrderedOptions.new
    h.apple = 'シナノゴールド'
    h
  end

  def ordered_with_int_key
    h = ActiveSupport::OrderedOptions.new

    # SyntaxError
    # no .<digit> floating literal anymore; put 0 before dot
    # h.1 = 'ふじ'

    h
  end

  ## nested
  def nested_ordered
    # {
    #   fruit: {
    #     apple:  {
    #       name: 'シナノゴールド',
    #       area: [
    #         { name: '青森県' },
    #         { name: '長野県' },
    #       ]
    #     }
    #   }
    # }

    fruit = ActiveSupport::OrderedOptions.new
    fruit.apple = ActiveSupport::OrderedOptions.new
    fruit.apple.name = 'シナノゴールド'

    aomori = ActiveSupport::OrderedOptions.new
    nagano = ActiveSupport::OrderedOptions.new

    fruit.apple.area = [aomori, nagano]
  end

  # ActiveSupport::InheritableOptions
  ## flat
  def inheritable_with_string_key
    ActiveSupport::InheritableOptions.new(hash_with_string_key)
  end

  def inheritable_with_int_key
    ActiveSupport::InheritableOptions.new(hash_with_int_key)
  end

  def inheritable_with_symbol_key
    ActiveSupport::InheritableOptions.new(hash_with_symbol_key)
  end

  def inheritable_with_string_and_symbol_key
    ActiveSupport::InheritableOptions.new(hash_with_string_and_symbol_key)
  end

  ## nested
  def nested_inheritable_with_string_key
    ActiveSupport::InheritableOptions.new(nested_hash_with_string_key)
  end

  def nested_inheritable_with_int_key
    ActiveSupport::InheritableOptions.new(nested_hash_with_int_key)
  end

  def nested_inheritable_with_symbol_key
    ActiveSupport::InheritableOptions.new(nested_hash_with_symbol_key)
  end

  def nested_inheritable_with_hash_transform
    ActiveSupport::InheritableOptions.new(hash_transform(nested_hash_with_symbol_key))
  end

  def nested_inheritable_with_hash_array_transform
    ActiveSupport::InheritableOptions.new(hash_array_transform(nested_hash_with_symbol_key))
  end

  def nested_inheritable_with_json_parse
    JSON.parse(nested_hash_with_symbol_key.to_json, object_class: ActiveSupport::OrderedOptions)
  end

  private def hash_transform(hash)
    hash.transform_values { |value| value.is_a?(Hash) ? ActiveSupport::InheritableOptions.new(hash_transform(value)) : value }
  end

  private def hash_array_transform(value)
    value.transform_values do |v|
      if v.is_a?(Hash)
        ActiveSupport::InheritableOptions.new(hash_array_transform(v))

      elsif v.is_a?(Array)
        v.map do |nested_v|
          ActiveSupport::InheritableOptions.new(hash_array_transform(nested_v))
        end

      else
        v
      end
    end
  end

  # OpenStruct
  # TODO: requireが上手く動かないので、いったん置いておく
  def nested_open_struct
    OpenStruct(nested_hash_with_symbol_key)
  end

  def nested_open_struct_with_json_parse
    JSON.parse(nested_hash_with_symbol_key, object_class: OpenStruct)
  end



  # recursive_open_struct

end