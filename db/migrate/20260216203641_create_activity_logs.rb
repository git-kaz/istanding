class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      # session_idはnull許可にして、セッションがない場合もログを残せるようにする
      t.references :sitting_session, null: true, foreign_key: true

      t.timestamps
    end
  end
end
