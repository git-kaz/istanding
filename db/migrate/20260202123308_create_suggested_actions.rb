class CreateSuggestedActions < ActiveRecord::Migration[8.1]
  def change
    create_table :suggested_actions do |t|
      t.references :sitting_session, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
