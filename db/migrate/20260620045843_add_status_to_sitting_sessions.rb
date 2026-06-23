class AddStatusToSittingSessions < ActiveRecord::Migration[8.1]
  def change
    # statusカラムの存在により本番エラーを防ぐため、カラムが存在する場合は追加しないようにする
    return if column_exists?(:sitting_sessions, :status)
    add_column :sitting_sessions, :status, :integer, default: 0, null: false
  end
end
