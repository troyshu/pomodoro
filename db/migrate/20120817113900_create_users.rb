class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :user_level, :default => 1

      t.timestamps
    end
  end
end
