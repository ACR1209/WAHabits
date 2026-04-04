class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.string :title
      t.string :description
      t.integer :completion_type
      t.integer :completion_threshold
      t.integer :goal_type
      t.integer :goal_amount

      t.timestamps
    end
  end
end
