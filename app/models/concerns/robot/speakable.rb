module Robot::Speakable
  extend ActiveSupport::Concern

  # モデルのコールバックを使う(ただし、メソッドと同じように定義するとエラーになる)
  # after_initialize :add_name_by_speakable
  # => NoMethodError:
  #    undefined method `after_initialize' for Robot::Speakable:Module

  # Concernだけに存在するメソッド
  def speak
    'Hello, world!'
  end

  # モデルとConcernで名前が重複しているメソッド
  def same_method_as_speakable
    '話します'
  end

  # モデルのコールバックで呼ばれる関数
  private def add_name_by_speakable
    self.name = self.name.present? ? self.name + 'add_speakable' : 'speakable'
  end
end