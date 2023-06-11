class CreateRobots < ActiveRecord::Migration[7.0]
  def change
    create_table :robots do |t|
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end
