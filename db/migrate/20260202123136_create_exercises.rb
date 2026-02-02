class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.string :name
      t.integer :category
      t.text :description
      t.string :cloudinary_public_id

      t.timestamps
    end
  end
end
