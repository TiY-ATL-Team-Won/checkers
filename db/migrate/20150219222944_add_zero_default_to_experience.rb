class AddZeroDefaultToExperience < ActiveRecord::Migration
  def change
  	change_column_default :users, :experience, 0
  end
end
