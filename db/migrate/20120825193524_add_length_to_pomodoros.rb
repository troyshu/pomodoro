class AddLengthToPomodoros < ActiveRecord::Migration
  def change
    add_column :pomodoros, :length, :integer, :default => 0
  end
end
