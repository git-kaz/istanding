class CreateSittingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sitting_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :notify_at
      t.boolean :notified
      t.string :endpoint
      t.string :p256dh
      t.string :auth

      t.timestamps
    end
  end
end
