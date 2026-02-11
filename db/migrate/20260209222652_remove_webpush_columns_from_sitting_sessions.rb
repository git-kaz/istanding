class RemoveWebpushColumnsFromSittingSessions < ActiveRecord::Migration[8.1]
  def change
    remove_column :sitting_sessions, :endpoint, :string
    remove_column :sitting_sessions, :p256dh, :string
    remove_column :sitting_sessions, :auth, :string
  end
end
