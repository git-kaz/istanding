class AddHpToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :hp, :integer, default: 100
  end
end
