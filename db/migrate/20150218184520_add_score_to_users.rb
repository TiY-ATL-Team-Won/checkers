class AddScoreToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :wins, :integer
  	add_column :users, :losses, :integer
  	add_column :users, :draws, :integer
  	add_column :users, :experience, :integer
  end
end
