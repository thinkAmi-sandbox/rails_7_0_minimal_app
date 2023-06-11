module Robot::WalkableWithIncluded
  extend ActiveSupport::Concern

  included do
    after_initialize :add_name_by_walkable

    # モデルとConcernで名前が重複しているメソッド
    def same_method_as_walkable_included
      'includeの中で歩きます'
    end
  end

  def walk
    'step forward'
  end

  # こちらも、モデルとConcernで名前が重複しているメソッド
  def same_method_as_walkable
    '歩きます'
  end

  private def add_name_by_walkable
    self.name = 'walkable'
  end
end
