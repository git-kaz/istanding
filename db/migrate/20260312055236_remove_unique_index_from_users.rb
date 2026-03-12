class RemoveUniqueIndexFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, [:provider, :uid]
    add_index :users, [:provider, :uid] 
  end
end
