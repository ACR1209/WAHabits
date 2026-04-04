class CreateHabitCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_completions do |t|
      t.references :habit, null: false, foreign_key: true
      t.timestamp :completion_date
      t.integer :completion_amount

      t.timestamps
    end
  end
end
