class DropSuggestedActions < ActiveRecord::Migration[8.1]
  def change
    drop_table :suggested_actions
  end
end
