class AddNoteAndDurationMinutesToActivityLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :activity_logs, :note, :text
    add_column :activity_logs, :duration_minutes, :integer
  end
end
