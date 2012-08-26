class CreatePomodoros < ActiveRecord::Migration
  def change
    create_table :pomodoros do |t|
      t.boolean :finished
      t.integer :user_id

      t.timestamps
    end
    add_index :pomodoros, [:user_id, :created_at]
  end
end
