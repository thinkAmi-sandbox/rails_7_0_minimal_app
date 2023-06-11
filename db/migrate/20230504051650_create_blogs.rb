class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :name
      t.boolean :published
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end