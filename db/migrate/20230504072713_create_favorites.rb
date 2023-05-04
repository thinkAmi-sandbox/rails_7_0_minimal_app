class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.string :name
      t.boolean :is_secret

      t.timestamps
    end
  end
end
