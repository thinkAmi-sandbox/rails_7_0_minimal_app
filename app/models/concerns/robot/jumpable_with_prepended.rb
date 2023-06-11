module Robot::JumpableWithPrepended
  extend ActiveSupport::Concern

  prepended do
    after_initialize :add_note_by_jumpable

    # モデルと同名のメソッド
    def same_method_as_jumpable_prepended
      'prependedの中でジャンプします'
    end
  end

  def jump
    'jump!'
  end

  # こちらもモデルと同名のメソッド
  def same_method_as_jumpable
    'ジャンプします'
  end

  private def add_note_by_jumpable
    self.note = 'jumpable'
  end
end
