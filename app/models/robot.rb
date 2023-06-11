# == Schema Information
#
# Table name: robots
#
#  id         :integer          not null, primary key
#  name       :string
#  note       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Robot < ApplicationRecord
  include Robot::Speakable
  include Robot::WalkableWithIncluded
  prepend Robot::JumpableWithPrepended

  # モデルだけにあるメソッド
  def robot_method
    'called robot method'
  end

  # Concernと名前が重複するメソッド
  def same_method_as_speakable
    'speak'
  end

  # Concernと名前が重複するメソッド(includedの外で定義)
  def same_method_as_walkable
    'walk'
  end

  # Concernと名前が重複するメソッド(includedの中で定義)
  def same_method_as_walkable_included
    'walk included'
  end

  # Concernと名前が重複するメソッド(prependedの外で定義)
  def same_method_as_jumpable
    'jump'
  end

  # Concernと名前が重複するメソッド(prependedの中で定義)
  def same_method_as_jumpable_prepended
    'jump prepended'
  end
end
