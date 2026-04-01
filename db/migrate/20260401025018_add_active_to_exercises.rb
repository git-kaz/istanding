class AddActiveToExercises < ActiveRecord::Migration[8.1]
  def change
    # カラムがまだ存在しない時だけ追加する
    unless column_exists?(:exercises, :active)
      add_column :exercises, :active, :boolean, default: true, null: false
    end
  end
end
