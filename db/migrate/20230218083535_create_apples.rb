class CreateApples < ActiveRecord::Migration[7.0]
  def change
    create_table :apples do |t|
      t.string :name
      t.integer :color
      t.integer :weight
      t.datetime :starts_at
      t.boolean :is_imported
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
