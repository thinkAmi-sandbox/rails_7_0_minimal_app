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
FactoryBot.define do
  factory :apple do
    name { '秋映' }
    weight { 300 }
    is_imported { false }

    trait :red do
      color { Apple.colors[:red] }
    end

    trait :yellow do
      color { Apple.colors[:yellow] }
    end

    trait :green do
      color { Apple.colors[:green] }
    end

    trait :early_sep do
      starts_at { Time.zone.local(2023, 9, 1) }
    end

    trait :mid_sep do
      starts_at { Time.zone.local(2023, 9, 10) }
    end

    trait :late_sep do
      starts_at { Time.zone.local(2023, 9, 20) }
    end

    trait :early_oct do
      starts_at { Time.zone.local(2023, 10, 1) }
    end

    trait :mid_oct do
      starts_at { Time.zone.local(2023, 10, 10) }
    end

    trait :late_oct do
      starts_at { Time.zone.local(2023, 10, 20) }
    end

    trait :early_nov do
      starts_at { Time.zone.local(2023, 11, 1) }
    end

    trait :mid_nov do
      starts_at { Time.zone.local(2023, 11, 10) }
    end

    trait :late_nov do
      starts_at { Time.zone.local(2023, 11, 20) }
    end

    # ネストして関連先を生成
    ## 関連を利用
    ### 暗黙
    factory :apple_association_by_implicit do
      # Areaのfactory名(area)と、Appleモデルの関連名(belongs_to)が同じ場合、暗黙的な関連を使える
      area
    end

    ### 明示
    factory :apple_association_by_explicit do
      association :area
    end

    ### インライン
    factory :apple_association_by_inline do
      area { association :area }
    end

    ## factoryを利用
    ### 暗黙
    factory :apple_factory_by_implicit do
      area factory: :aomori_area
    end

    ### 明示
    factory :apple_factory_by_explicit do
      association :area, factory: :nagano_area
    end

    ### インライン
    factory :apple_factory_by_inline do
      area { association :iwate_area }
    end

    ### 属性上書き
    factory :apple_factory_with_overriding_attributes do
      association :area, factory: :area, name: '山形県'
    end

    # traitで生成
    trait :aomori_apple do
      association :area, factory: :aomori_area
    end

    trait :hokkaido_apple do
      association :area, factory: :hokkaido_area
    end

    # 複数のtraitを指定したfactory
    # 同じ属性に対し別の値を設定している場合、後で指定したtraitの値が使われる
    factory :multiple_traits, traits: %i[aomori_apple hokkaido_apple]

    trait :with_transient do
      transient do
        is_nagano { false }
      end

      after(:create) do |apple, evaluator|
        if evaluator.is_nagano
          # areaはoptionalなbelongs_toなので、後から追加可能
          apple.area = create(:nagano_area)
          apple.name = "シナノ#{apple.name}"
          apple.save!
        end
      end
    end
  end

  # parent指定して関連先を生成
  factory :apple_with_parent, parent: :apple do
    area
  end
end
