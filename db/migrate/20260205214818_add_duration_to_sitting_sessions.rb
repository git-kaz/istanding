class AddDurationToSittingSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sitting_sessions, :duration, :integer
  end
end
