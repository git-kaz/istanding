class RemoveActiveFromExercises < ActiveRecord::Migration[8.1]
  def change
    # column_exists? を使って、カラムがある時だけ削除するようにガードを入れる
    if column_exists?(:exercises, :active)
    remove_column :exercises, :active, :boolean
  end
end
