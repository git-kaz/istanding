class AddWebpushColumnsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :endpoint, :string
    add_column :users, :p256dh, :string
    add_column :users, :auth, :string
  end
end
