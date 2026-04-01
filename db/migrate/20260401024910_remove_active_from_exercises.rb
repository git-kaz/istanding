class RemoveActiveFromExercises < ActiveRecord::Migration[8.1]
  def change
    remove_column :exercises, :active, :boolean
  end
end
