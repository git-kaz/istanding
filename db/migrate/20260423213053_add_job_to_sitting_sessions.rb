class AddJobToSittingSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sitting_sessions, :job_id, :string
  end
end
