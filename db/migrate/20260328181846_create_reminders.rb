class CreateReminders < ActiveRecord::Migration[8.1]
  def change
    create_table :reminders do |t|
      t.string :title
      t.string :description
      t.timestamp :due
      t.boolean :done

      t.timestamps
    end
  end
end
