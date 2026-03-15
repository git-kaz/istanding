class RenameDescriptionAndAddBenefitsToExercise < ActiveRecord::Migration[8.1]
  def change
    rename_column :exercises, :description, :instructions
    add_column :exercises, :benefits, :text
  end
end
