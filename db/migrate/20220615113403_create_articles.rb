class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :release, null: false, default: 0
      t.integer :payment, null: false, default: 0

      t.timestamps
    end
  end
end
