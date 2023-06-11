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
require 'rails_helper'

RSpec.describe Robot, type: :model do
  describe 'Robot::Speakable' do
    let(:actual) { Robot.new }

    it 'モデルのメソッドを呼ぶことができる' do
      expect(actual.robot_method).to eq('called robot method')
    end

    it 'speakableのメソッドを呼ぶことができる' do
      expect(actual.speak).to eq('Hello, world!')
    end

    it 'モデルとConcernに同名のメソッドがある場合は、モデルのメソッドが使われる' do
      expect(actual.same_method_as_speakable).to eq('speak')
    end

    xit 'included/prependedが定義されていないので、コールバックは使えない'
  end

  describe 'Robot::WalkableWithIncluded' do
    let(:actual) { Robot.new }

    it 'モデルのメソッドを呼ぶことができる' do
      expect(actual.robot_method).to eq('called robot method')
    end

    it 'WalkableWithIncludedのメソッドを呼ぶことができる' do
      expect(actual.walk).to eq('step forward')
    end

    it 'モデルとincludedの外で同名のメソッドが定義されている場合は、モデルのメソッドが使われる' do
      expect(actual.same_method_as_walkable).to eq('walk')
    end

    it 'モデルとincludedの中で同名のメソッドが定義されている場合も、モデルのメソッドが使われる' do
      expect(actual.same_method_as_walkable_included).to eq('walk included')
    end

    it 'includedにて定義されたコールバックが使える' do
      expect(actual.name).to eq('walkable')
    end
  end

  describe 'Robot::JumpableWithPrepended' do
    let(:actual) { Robot.new }

    it 'モデルのメソッドを呼ぶことができる' do
      expect(actual.robot_method).to eq('called robot method')
    end

    it 'JumpableWithIncludedのメソッドを呼ぶことができる' do
      expect(actual.jump).to eq('jump!')
    end

    it 'モデルとprependedの外で同名のメソッドが定義されている場合は、Concernのメソッドが使われる' do
      expect(actual.same_method_as_jumpable).to eq('ジャンプします')
    end

    it 'モデルとprependedの中で同名のメソッドが定義されている場合も、モデルのメソッドが使われる' do
      expect(actual.same_method_as_jumpable_prepended).to eq('jump prepended')
    end

    it 'prependedにて定義されたコールバックが使える' do
      expect(actual.note).to eq('jumpable')
    end
  end
end
