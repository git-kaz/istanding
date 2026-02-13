class AddSittingSessions < ActiveRecord::Migration[8.1]
  def change
    # セッションの状態を管理するためのカラム
    add_column :sitting_sessions, :status, :integer, default: 0, null: false
  end
end
