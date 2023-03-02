# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :area do
    name { '日本' }

    factory :aomori_area do
      name { '青森県' }
    end

    factory :nagano_area do
      name { '長野県' }
    end

    factory :iwate_area do
      name { '岩手県' }
    end

    # callbackで生成
    factory :callback_area do
      name { '秋田県' }
      after(:create) { |area| create(:apple, area: area) }
    end

    factory :hokkaido_area do
      name { '北海道' }
    end
  end
end