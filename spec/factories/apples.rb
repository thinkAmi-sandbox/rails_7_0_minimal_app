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
  end
end
