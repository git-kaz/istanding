class AddStatusToSittingSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sitting_sessions, :status, :integer, default: 0, null: false
  end
end
